Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3IXRIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:08:53 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:35948 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3IXRIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:08:52 -0400
Date: Tue, 24 Sep 2013 14:08:42 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: Use per-file CFLAGS in Makefile
Message-ID: <20130924170842.GA2634@ghostprotocols.net>
References: <1379297476-20793-1-git-send-email-namhyung@kernel.org>
 <20130920230132.GK9574@pd.tnic>
 <878uynrjaa.fsf@sejong.aot.lge.com>
 <20130923092659.GD2527@pd.tnic>
 <87vc1qprny.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc1qprny.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 24, 2013 at 05:09:21PM +0900, Namhyung Kim escreveu:
> On Mon, 23 Sep 2013 11:26:59 +0200, Borislav Petkov wrote:
> > On Mon, Sep 23, 2013 at 06:15:09PM +0900, Namhyung Kim wrote:
> >> I replaced them to a single -w option since all we want to do is
> >> suppress any warning, right?

> > Do we? And besides, -w is a big hammer as it shuts up all warnings.
> > acme?

> > I think special handling those files grew out of necessity to shut up
> > some warnings but acme would know better.

Yes, there were reasons for disabling some warnings on some files, would
have to look at the git history to see...

commit 09c0211c0bb0e40231e6ee9a35041d467ed72f16
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri May 4 11:32:54 2012 -0700

    perf: Turn off compiler warnings for flex and bison generated files
    
    We don't know what types of warnings different versions of flex
    and bison combined with different versions of gcc is going to
    generate, so just punt and don't warn about anything.
    
    This fixes the build of perf for me on an openSUSE 12.1 system.


commit 575bf1d04e908469d26da424b52fc1b12a1db9d8
Author: Kirill A. Shutemov <kirill@shutemov.name>
Date:   Mon Jun 24 11:43:14 2013 +0300

    perf tools: Fix build with perl 5.18
    
    perl.h from new Perl release doesn't like -Wundef and -Wswitch-default:

etc.

 
> I don't know.  I just thought there's not much thing we can do for those
> files other than shutting up all warnings.
 
> But if you think that's not the right thing, I'll keep the existing
> options.  What do you think, Arnaldo?

I think keeping the existing options is the right thing to do, if some
of that can be simplified or made like you did it in your patch, then
that is the matter for a separate patch, with proper explanation.
 
- Arnaldo
