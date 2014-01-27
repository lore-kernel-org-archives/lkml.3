Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaA0OOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:14:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:32986 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbaA0OO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:14:29 -0500
Message-ID: <52E669C0.7040002@cloudius-systems.com>
Date: Mon, 27 Jan 2014 16:14:24 +0200
From: Avi Kivity <avi@cloudius-systems.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Avi Kivity <avi@cloudius-systems.com>
Subject: Re: [PATCH] perf tools: demangle kernel and kernel module symbols
 too
References: <26f71bf5bf7ee1408e3f1a803556d5df18223ef1.1390420726.git.avi@cloudius-systems.com>
In-Reply-To: <26f71bf5bf7ee1408e3f1a803556d5df18223ef1.1390420726.git.avi@cloudius-systems.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 09:58 PM, Avi Kivity wrote:
> Some kernels contain C++ code, and thus their symbols need to be demangled.
> This allows 'perf kvm top' to generate readable output.

Ping?

> Signed-off-by: Avi Kivity <avi@cloudius-systems.com>
> ---
>   tools/perf/util/symbol-elf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 7594567..8f12f0f 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -922,6 +922,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
>   				  (u64)shdr.sh_offset);
>   			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
>   		}
> +new_symbol:
>   		/*
>   		 * We need to figure out if the object was created from C++ sources
>   		 * DWARF DW_compile_unit has this, but we don't always have access
> @@ -933,7 +934,6 @@ int dso__load_sym(struct dso *dso, struct map *map,
>   			if (demangled != NULL)
>   				elf_name = demangled;
>   		}
> -new_symbol:
>   		f = symbol__new(sym.st_value, sym.st_size,
>   				GELF_ST_BIND(sym.st_info), elf_name);
>   		free(demangled);

