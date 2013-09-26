Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3IZHWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:22:15 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:56346 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3IZHWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:22:14 -0400
Message-ID: <5243E0A3.1060900@gmail.com>
Date: Thu, 26 Sep 2013 09:22:11 +0200
From: Richard Genoud <richard.genoud@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] UBI: Call scan_all() with correct offset in error
 case
References: <1380141125-11063-1-git-send-email-richard@nod.at> <1380141125-11063-2-git-send-email-richard@nod.at>
In-Reply-To: <1380141125-11063-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/09/2013 22:32, Richard Weinberger wrote:
> If we find an invalid fastmap we have to scan from the very beginning.
> Otherwise we leak the first 64 PEBs.
> 
> Reported-by: Richard Genoud <richard.genoud@gmail.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/attach.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
> index c071d41..03b32b0 100644
> --- a/drivers/mtd/ubi/attach.c
> +++ b/drivers/mtd/ubi/attach.c
> @@ -1417,9 +1417,11 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
>  				ai = alloc_ai("ubi_aeb_slab_cache2");
>  				if (!ai)
>  					return -ENOMEM;
> -			}
>  
> -			err = scan_all(ubi, ai, UBI_FM_MAX_START);
> +				err = scan_all(ubi, ai, 0);
> +			} else {
> +				err = scan_all(ubi, ai, UBI_FM_MAX_START);
> +			}
>  		}
>  	}
>  #else
> 

Works great, the assert is not triggered anymore.

Tested-by: Richard Genoud <richard.genoud@gmail.com>
