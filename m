Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaKQCEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 21:04:45 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:45395 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaKQCEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 21:04:43 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on NO_LIBELF=1
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
	<20141107152931.GN18464@kernel.org>
	<87egtbv965.fsf@sejong.aot.lge.com>
	<20141110121141.GP18464@kernel.org>
Date: Mon, 17 Nov 2014 11:04:40 +0900
In-Reply-To: <20141110121141.GP18464@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 10 Nov 2014 09:11:41 -0300")
Message-ID: <87wq6utwef.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 09:11:41 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 10, 2014 at 03:53:06PM +0900, Namhyung Kim escreveu:
>> On Fri, 7 Nov 2014 12:29:31 -0300, Arnaldo Carvalho de Melo wrote:
>> > Em Fri, Nov 07, 2014 at 02:20:04PM +0900, Namhyung Kim escreveu:
>> >> When libelf is not used, perf cannot not show symbol names since it
>> >> doesn't access the ELF symbol table.  But kernel is different as it
>> >> can fallback to kallsyms.
>
>> >> It worked w/o libelf, but recent change to use vmlinux for kernel
>> >> symbols break it.
>
>> >> With this change, it now can show kernel symbols again:
>
>> > Ok, but since you added that minimal ELF symtab loading, isn't better to
>> > try that first, i.e. if we find a vmlinux file with a build-id and with
>> > symbols in it...
>
>> > If that isn't the case, i.e. no vmlinux was found, then we fallback to
>> > kallsyms, to check if that is available.
>
>> > I.e. with your new minimalistic ELF symtab loader if we have a suitable
>> > vmlinux but no kallsyms, we end up resolving no symbols even having that
>> > nice vmlinux :-)
>> 
>> Yeah, maybe.  But it'd add a substantial complexity also and I tried to
>> make it simple and small only to show usual userspace symbols.
>> 
>> I think that about a half of the complexity of the dso__load_sym() in
>> symbol-elf.c came from the kernel (and module) support.  And expecting
>
> Right, I agree that thing grew too complex, reducing that complexity is
> something we should do when we have the chance. I.e. perhaps we could
> separate kernel/modules handling out of it, even if just at source code
> level at first...

Hmm.. okay.  I'll try.

Thanks,
Namhyung


>
>> kallsyms on the system is not a high barrier IMHO.  So I decided to just
>> fall back to kallsyms for kernel dsos.  Mayby we can add the kernel
>> support incrementally later.
>
> The suggestion came because you did that minimalistic reader, which if
> can be used for vmlinux files, would be great, as resolving vmlinux
> samples is such a major usecase :-)
