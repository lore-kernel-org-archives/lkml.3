Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaA0OsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:48:19 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:37475 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaA0OsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:48:18 -0500
Date: Mon, 27 Jan 2014 11:48:12 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Avi Kivity <avi@cloudius-systems.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf tools: demangle kernel and kernel module symbols too
Message-ID: <20140127144812.GB3998@ghostprotocols.net>
References: <26f71bf5bf7ee1408e3f1a803556d5df18223ef1.1390420726.git.avi@cloudius-systems.com>
 <52E669C0.7040002@cloudius-systems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E669C0.7040002@cloudius-systems.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 27, 2014 at 04:14:24PM +0200, Avi Kivity escreveu:
> On 01/22/2014 09:58 PM, Avi Kivity wrote:
> >Some kernels contain C++ code, and thus their symbols need to be demangled.
> >This allows 'perf kvm top' to generate readable output.
> 
> Ping?

Applied, should be on my next pull req to Ingo,

- Arnaldo
 
> >Signed-off-by: Avi Kivity <avi@cloudius-systems.com>
> >---
> >  tools/perf/util/symbol-elf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> >index 7594567..8f12f0f 100644
> >--- a/tools/perf/util/symbol-elf.c
> >+++ b/tools/perf/util/symbol-elf.c
> >@@ -922,6 +922,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
> >  				  (u64)shdr.sh_offset);
> >  			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
> >  		}
> >+new_symbol:
> >  		/*
> >  		 * We need to figure out if the object was created from C++ sources
> >  		 * DWARF DW_compile_unit has this, but we don't always have access
> >@@ -933,7 +934,6 @@ int dso__load_sym(struct dso *dso, struct map *map,
> >  			if (demangled != NULL)
> >  				elf_name = demangled;
> >  		}
> >-new_symbol:
> >  		f = symbol__new(sym.st_value, sym.st_size,
> >  				GELF_ST_BIND(sym.st_info), elf_name);
> >  		free(demangled);
