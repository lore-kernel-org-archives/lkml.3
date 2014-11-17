Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaKQS7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:59:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaKQS7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:59:18 -0500
Date: Mon, 17 Nov 2014 16:58:57 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
Message-ID: <20141117185857.GC2207@redhat.com>
References: <874muew2hk.fsf@sejong.aot.lge.com>
 <5459E865.6050207@hitachi.com>
 <545B1DDE.9000202@linux.vnet.ibm.com>
 <545C80F4.4020905@hitachi.com>
 <54609A8C.4050308@hitachi.com>
 <20141110122321.GC4468@redhat.com>
 <5461B276.50004@hitachi.com>
 <20141111131030.GG4468@redhat.com>
 <54637C05.5090807@hitachi.com>
 <87oas6ttf8.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oas6ttf8.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 17, 2014 at 12:08:59PM +0900, Namhyung Kim escreveu:
> On Thu, 13 Nov 2014 00:25:57 +0900, Masami Hiramatsu wrote:
> > (2014/11/11 22:10), Arnaldo Carvalho de Melo wrote:
> >> What I meant was, what is wrong with replacing:

> >>  perf cache --probe <SPEC>  # for the current kernel

> >> With:

> >>  perf cache --add <PROBE-SPEC> # for the current kernel

> >> And have it figure out that what is being added is a probe and do the
> >> right thing?

> > As I've said previously, PROBE-SPEC can be same as FILES (imagine that a binary
> > file which has same name function in the kernel.)
> > Moreover, PROBE-SPEC requires the target binary(or kernel module) except for
> > kernel probes. In that case, anyway we need -x or -m options with file-path
> > for --add, that is very strange.

> > e.g.

> > For me,

> >  perf cache --add ./binary --probe '*'

> > looks more natural than

> >  perf cache --add '*' -exec ./binary

> > since in other cases(sdt/elf), we'll just do

> >  perf cache --add ./binary
 
> I prefer this too.  But I'd like make the 'add' part a subcommand rather
> than option like we do in perf kmem/kvm/list/lock/mem/sched ...  And it
> can handle multiple files at once.  What about this?
 
>   perf cache add [--elf|--sdt|--probe <spec>] <binary> [<binary>...]

In the end we can have it both ways, i.e. if the user does just:

    perf cache add something

or:

    perf cache add --elf something

And 'something' is an ELF file, then in the first case (no --elf
specified) it will figure it out (checking the magic number, etc) and do
the right thing.

In the second case since we're being more verbose and think we know what
'something' is (an ELF file) the tool can check if it indeed is an ELF
file and if not, bail out.

- Arnaldo
