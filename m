Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3ISVIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:08:19 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:53011 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab3ISVIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:08:17 -0400
Message-ID: <523B67B8.2060706@hauke-m.de>
Date: Thu, 19 Sep 2013 23:08:08 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: thomas@m3y3r.de, linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/10] MIPS: BCM47XX: Cocci spatch "noderef"
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de> <1379604755851-1504037195-1-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1379604755851-1504037195-1-diffsplit-thomas@m3y3r.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 08:38 PM, thomas@m3y3r.de wrote:
> sizeof when applied to a pointer typed expression gives the size of the
> pointer.
> Found by coccinelle spatch "misc/noderef.cocci"

Thanks for spotting this.

Is this a new rule or has just nobody checked that part of the kernel?


The from field in the mail is broken.

> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> diff -u -p a/arch/mips/bcm47xx/sprom.c b/arch/mips/bcm47xx/sprom.c
> --- a/arch/mips/bcm47xx/sprom.c
> +++ b/arch/mips/bcm47xx/sprom.c
> @@ -162,7 +162,7 @@ static void nvram_read_alpha2(const char
>  		pr_warn("alpha2 is too long %s\n", buf);
>  		return;
>  	}
> -	memcpy(val, buf, sizeof(val));
> +	memcpy(val, buf, sizeof(*val));
>  }
>  
>  static void bcm47xx_fill_sprom_r1234589(struct ssb_sprom *sprom,
> 

