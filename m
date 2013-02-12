Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab3BLONN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:13:13 -0500
Received: from multi.imgtec.com ([194.200.65.239]:63242 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759093Ab3BLONM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:13:12 -0500
Message-ID: <511A4DF2.6070208@imgtec.com>
Date: Tue, 12 Feb 2013 14:13:06 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Arnd <arnd@arndb.de>
Subject: Re: [PATCH 1/1] genksyms: fix metag symbol prefix on crc symbols
References: <1360598235-11188-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1360598235-11188-1-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_12_14_13_11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/13 15:57, James Hogan wrote:
> Meta uses symbol prefixes, so add "metag" to the list of architectures
> to set the mod_prefix to "_" for. This fixes __crc_* symbols to add the
> extra underscore to match _CRC_SYMBOL macro in <linux/export.h> and so
> that modpost finds them.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Unless anybody raises any objections I'll add this to the metag tree as
it's pretty trivial.

Cheers
James

> ---
>  scripts/genksyms/genksyms.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
> index 8a10649..d25e4a1 100644
> --- a/scripts/genksyms/genksyms.c
> +++ b/scripts/genksyms/genksyms.c
> @@ -826,7 +826,8 @@ int main(int argc, char **argv)
>  			genksyms_usage();
>  			return 1;
>  		}
> -	if ((strcmp(arch, "h8300") == 0) || (strcmp(arch, "blackfin") == 0))
> +	if ((strcmp(arch, "h8300") == 0) || (strcmp(arch, "blackfin") == 0) ||
> +	    (strcmp(arch, "metag") == 0))
>  		mod_prefix = "_";
>  	{
>  		extern int yydebug;
> 

