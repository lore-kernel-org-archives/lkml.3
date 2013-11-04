Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3KDPxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:53:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab3KDPxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:53:00 -0500
Date: Mon, 4 Nov 2013 16:51:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch
	methods (v6)
Message-ID: <20131104155131.GD4440@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com> <87fvrc35kj.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvrc35kj.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04, Namhyung Kim wrote:
> On Mon, 04 Nov 2013 17:46:41 +0900, Namhyung Kim wrote:
> > On Sat, 2 Nov 2013 16:54:58 +0100, Oleg Nesterov wrote:
> >> - this only allows to read the data from the same binary.
> >
> > Right.  This is also an unnecessary restriction.  We should be able to
> > access data in other binary.
>
> Hmm.. I guess this gonna be not simple

Yes ;)

- perhaps it can only be
> supported for per-process uprobe with known virtual addresses?

"Known" is very limited. Even in the simplest case (like your test-case
from from 0/13), you simply can't know the address of "int glob" if you
compile it with "-pie -fPIC".

As for other binaries (say libc) the problem is even worse, and
randomize_va_space adds even more pain.

But in any case, I strongly believe that it doesn't make any sense to
rely on tu->inode in get_user_vaddr().

Oleg.

