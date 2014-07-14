Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbaGNUim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:38:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:56865 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbaGNUik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:38:40 -0400
Date: Mon, 14 Jul 2014 17:38:35 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 08/41] perf tools: Fix missing label symbols
Message-ID: <20140714203835.GB18133@kernel.org>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-9-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405332185-4050-9-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 14, 2014 at 01:02:32PM +0300, Adrian Hunter escreveu:
> label symbols are missing because elf_sec__is_a() fails
> to find the section because the section strings do not
> match the section headers because the sections headers
> are from the 'runtime' object and the sections strings
> are from the 'symbol source' object.
> 
> Fix by getting the section strings from the 'runtime'
> object so that they match the section headers.

Would be great to have a 'perf test' entry that fail when looking for
those 'label symbols', i.e. looking for one such symbol in vmlinux that
we know is always there, in some written in stone area of the kernel,
where this label vanishing is unlikely to happen.

Can you elaborate on the case that fails? So that I can test it here,
and then after the fix, check that it indeed fixes the problem? I may
well write that test myself and insert it in my branch just before this
one.

- Arnaldo
 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/symbol-elf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 6864661..8c96817 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -732,7 +732,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
>  	if (symstrs == NULL)
>  		goto out_elf_end;
>  
> -	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
> +	sec_strndx = elf_getscn(runtime_ss->elf, runtime_ss->ehdr.e_shstrndx);
>  	if (sec_strndx == NULL)
>  		goto out_elf_end;
>  
> -- 
> 1.8.3.2
