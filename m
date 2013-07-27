Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab3G0RxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 13:53:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59429 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752334Ab3G0RxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 13:53:21 -0400
Message-ID: <1374947600.2075.3.camel@joe-AO722>
Subject: Re: [PATCH 2/2] i2c.c: Fixed coding style issue for if statement
From: Joe Perches <joe@perches.com>
To: "santosh.anbu" <asantoshking@gmail.com>
Cc: airlied@linux.ie, asantosh.king@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Sat, 27 Jul 2013 10:53:20 -0700
In-Reply-To: <1374947316-7864-1-git-send-email-asantosh.king@gmail.com>
References: <1374947316-7864-1-git-send-email-asantosh.king@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-27 at 23:18 +0530, santosh.anbu wrote:
> From: "santosh.anbu" <asantosh.king@gmail.com>
[]
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c b/drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c
> index cfb9288..e88529c 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/bios/i2c.c
> @@ -114,15 +114,19 @@ dcb_i2c_parse(struct nouveau_bios *bios, u8 idx, struct dcb_i2c_entry *info)
>  
>  		if (idx == 0) {
>  			info->drive = nv_ro08(bios, ent + 4);
> -			if (!info->drive) info->drive = 0x3f;
> +			if (!info->drive)
> +				info->drive = 0x3f;
>  			info->sense = nv_ro08(bios, ent + 5);
> -			if (!info->sense) info->sense = 0x3e;
> +			if (!info->sense)
> +				info->sense = 0x3e;
>  		} else
>  		if (idx == 1) {
>  			info->drive = nv_ro08(bios, ent + 6);
> -			if (!info->drive) info->drive = 0x37;
> +			if (!info->drive)
> +				info->drive = 0x37;
>  			info->sense = nv_ro08(bios, ent + 7);
> -			if (!info->sense) info->sense = 0x36;
> +			if (!info->sense)
> +				info->sense = 0x36;
>  		}
>  
>  		info->type  = DCB_I2C_NV04_BIT;

Perhaps this is better handled with a new function like

int nv_ro08_default(bios, address, default)
{
	int val = nv_ro08(bios, address);
	if (val == 0)
		val = default;
	return val;
}

