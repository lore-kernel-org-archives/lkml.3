Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab3DGJIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 05:08:48 -0400
Received: from canardo.mork.no ([148.122.252.1]:57402 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab3DGJIq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 05:08:46 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Chen Gang <gang.chen@asianux.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drivers: Base: Regmap: fix warnings, use %lu instead of %d for printf format
Organization: m
References: <5160E113.9080502@asianux.com>
Date: Sun, 07 Apr 2013 11:08:27 +0200
In-Reply-To: <5160E113.9080502@asianux.com> (Chen Gang's message of "Sun, 07
	Apr 2013 10:59:31 +0800")
Message-ID: <8761zybtdg.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:

>   fix warnings (with EXTRA_CFLAGS=-W):
>     format ‘%d’ expects argument of type ‘int’,
>     but argument 4 has type ‘size_t’ [-Wformat]
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/base/regmap/regcache.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
> index d81f605..275a2d2 100644
> --- a/drivers/base/regmap/regcache.c
> +++ b/drivers/base/regmap/regcache.c
> @@ -590,7 +590,7 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
>  
>  	count = cur - base;
>  
> -	dev_dbg(map->dev, "Writing %d bytes for %d registers from 0x%x-0x%x\n",
> +	dev_dbg(map->dev, "Writing %lu bytes for %d registers from 0x%x-0x%x\n",
>  		count * val_bytes, count, base, cur - 1);
>  
>  	map->cache_bypass = 1;


Please read Documentation/printk-formats.txt. Thanks.


Bjørn
