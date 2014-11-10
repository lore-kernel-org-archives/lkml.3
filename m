Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaKJMLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:11:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:47847 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbaKJMLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:11:46 -0500
Date: Mon, 10 Nov 2014 09:11:41 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on
 NO_LIBELF=1
Message-ID: <20141110121141.GP18464@kernel.org>
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
 <20141107152931.GN18464@kernel.org>
 <87egtbv965.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87egtbv965.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 10, 2014 at 03:53:06PM +0900, Namhyung Kim escreveu:
> On Fri, 7 Nov 2014 12:29:31 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Nov 07, 2014 at 02:20:04PM +0900, Namhyung Kim escreveu:
> >> When libelf is not used, perf cannot not show symbol names since it
> >> doesn't access the ELF symbol table.  But kernel is different as it
> >> can fallback to kallsyms.

> >> It worked w/o libelf, but recent change to use vmlinux for kernel
> >> symbols break it.

> >> With this change, it now can show kernel symbols again:

> > Ok, but since you added that minimal ELF symtab loading, isn't better to
> > try that first, i.e. if we find a vmlinux file with a build-id and with
> > symbols in it...

> > If that isn't the case, i.e. no vmlinux was found, then we fallback to
> > kallsyms, to check if that is available.

> > I.e. with your new minimalistic ELF symtab loader if we have a suitable
> > vmlinux but no kallsyms, we end up resolving no symbols even having that
> > nice vmlinux :-)
> 
> Yeah, maybe.  But it'd add a substantial complexity also and I tried to
> make it simple and small only to show usual userspace symbols.
> 
> I think that about a half of the complexity of the dso__load_sym() in
> symbol-elf.c came from the kernel (and module) support.  And expecting

Right, I agree that thing grew too complex, reducing that complexity is
something we should do when we have the chance. I.e. perhaps we could
separate kernel/modules handling out of it, even if just at source code
level at first...

> kallsyms on the system is not a high barrier IMHO.  So I decided to just
> fall back to kallsyms for kernel dsos.  Mayby we can add the kernel
> support incrementally later.

The suggestion came because you did that minimalistic reader, which if
can be used for vmlinux files, would be great, as resolving vmlinux
samples is such a major usecase :-)

- Arnaldo
