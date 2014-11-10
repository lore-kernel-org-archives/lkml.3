Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaKJGxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:53:10 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46686 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaKJGxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:53:08 -0500
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
Date: Mon, 10 Nov 2014 15:53:06 +0900
In-Reply-To: <20141107152931.GN18464@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Fri, 7 Nov 2014 12:29:31 -0300")
Message-ID: <87egtbv965.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014 12:29:31 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 07, 2014 at 02:20:04PM +0900, Namhyung Kim escreveu:
>> When libelf is not used, perf cannot not show symbol names since it
>> doesn't access the ELF symbol table.  But kernel is different as it
>> can fallback to kallsyms.
>> 
>> It worked w/o libelf, but recent change to use vmlinux for kernel
>> symbols break it.
>> 
>> With this change, it now can show kernel symbols again:
>
> Ok, but since you added that minimal ELF symtab loading, isn't better to
> try that first, i.e. if we find a vmlinux file with a build-id and with
> symbols in it...
>
> If that isn't the case, i.e. no vmlinux was found, then we fallback to
> kallsyms, to check if that is available.
>
> I.e. with your new minimalistic ELF symtab loader if we have a suitable
> vmlinux but no kallsyms, we end up resolving no symbols even having that
> nice vmlinux :-)

Yeah, maybe.  But it'd add a substantial complexity also and I tried to
make it simple and small only to show usual userspace symbols.

I think that about a half of the complexity of the dso__load_sym() in
symbol-elf.c came from the kernel (and module) support.  And expecting
kallsyms on the system is not a high barrier IMHO.  So I decided to just
fall back to kallsyms for kernel dsos.  Mayby we can add the kernel
support incrementally later.

Thanks,
Namhyung
