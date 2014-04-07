Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbaDGXsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:48:31 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35279 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbaDGXsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:48:30 -0400
Message-ID: <53433947.90908@hitachi.com>
Date: Tue, 08 Apr 2014 08:48:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf probe: Use dwarf_getcfi_elf() instead of dwarf_getcfi()
References: <1396854348-9296-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1396854348-9296-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/07 16:05), Namhyung Kim wrote:
> The dwarf_getcfi() only checks .debug_frame section for CFI, but as
> most binaries only have .eh_frame it'd return NULL and it makes
> some variables inaccessible.
> 
> Using dwarf_getcfi_elf (along with dwarf_getelf()) allows to show and
> add probe to more variables.
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Thank you for fixing :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
>  tools/perf/util/probe-finder.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 3bf0c8cdccb7..d58da0672736 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -985,7 +985,7 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
>  
>  #if _ELFUTILS_PREREQ(0, 142)
>  	/* Get the call frame information from this dwarf */
> -	pf->cfi = dwarf_getcfi(dbg->dbg);
> +	pf->cfi = dwarf_getcfi_elf(dwarf_getelf(dbg->dbg));
>  #endif
>  
>  	off = 0;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


