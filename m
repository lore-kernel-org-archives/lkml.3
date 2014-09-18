Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaIRIUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:20:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46650 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaIRIUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:20:19 -0400
Date: Thu, 18 Sep 2014 09:20:09 +0100
From: Jamie Iles <jamie.iles@oracle.com>
To: tim.gardner@canonical.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jamie Iles <jamie.iles@oracle.com>
Subject: Re: [PATCH 3.17-rc5 ] =?utf-8?Q?scripts=2F?=
 =?utf-8?Q?sortextable=3A_Suppress_warning=3A_=E2=80=98relocs=5Fsize?=
 =?utf-8?B?4oCZ?= may be used uninitialized
Message-ID: <20140918082009.GK27906@localhost>
References: <1410893362-17128-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410893362-17128-1-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Tue, Sep 16, 2014 at 12:49:22PM -0600, tim.gardner@canonical.com wrote:
> From: Tim Gardner <tim.gardner@canonical.com>
> 
> In file included from scripts/sortextable.c:194:0:
> scripts/sortextable.c: In function ‘main’:
> scripts/sortextable.h:176:3: warning: ‘relocs_size’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    memset(relocs, 0, relocs_size);
>    ^
> scripts/sortextable.h:106:6: note: ‘relocs_size’ was declared here
>   int relocs_size;
>       ^
> In file included from scripts/sortextable.c:192:0:
> scripts/sortextable.h:176:3: warning: ‘relocs_size’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>    memset(relocs, 0, relocs_size);
>    ^
> scripts/sortextable.h:106:6: note: ‘relocs_size’ was declared here
>   int relocs_size;
>       ^
> 
> gcc 4.9.1
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jamie Iles <jamie.iles@oracle.com>

Reviewed-by: Jamie Iles <jamie.iles@oracle.com>

> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
> 
> Is gcc 4.9 dumber then 4.8 ? gcc 4.8 doesn't produce this warning.

It's an odd one - I don't see how relocs_size can be uninitialized when 
relocs is non-null.  Your fix looks fine to me though.

Jamie

>  scripts/sortextable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/sortextable.h b/scripts/sortextable.h
> index 8fac3fd..ba87004 100644
> --- a/scripts/sortextable.h
> +++ b/scripts/sortextable.h
> @@ -103,7 +103,7 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
>  	Elf_Sym *sort_needed_sym;
>  	Elf_Shdr *sort_needed_sec;
>  	Elf_Rel *relocs = NULL;
> -	int relocs_size;
> +	int relocs_size = 0;
>  	uint32_t *sort_done_location;
>  	const char *secstrtab;
>  	const char *strtab;
> -- 
> 2.1.0
> 
