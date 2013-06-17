Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3FQNJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:09:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab3FQNJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:09:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <chao.xie@marvell.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, haojian.zhuang@gmail.com,
        xiechao.mail@gmail.com
Subject: Re: [PATCH V2 4/5] input: pxa27x-keypad: remove the unused members at platform data
Date: Mon, 17 Jun 2013 15:10:27 +0200
Message-ID: <5701258.F0sLjHKir2@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1367809448-9437-5-git-send-email-chao.xie@marvell.com>
References: <1367809448-9437-1-git-send-email-chao.xie@marvell.com> <1367809448-9437-5-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:sEAgdj4uIo9zZHawYkDdUMft0r/dd6AWU72dv6YlO75
 JNukVKfV2A69fcKl2pCuQt6SmUEAiySElrMeI1h/zq0bnxyZa8
 fmimar/SvP8xknw+2k7V0C22U2dMBZzDmonHA1UVULcepHToGq
 SZ5GXACIAaiBt8/iSSj9BVM7TsKKBYHJMj38GWDqDt5Ij5Ss4g
 EwH3GYXDZ2YiDaU0lzIDOLM2sKchlhg8JddYH2Tat9B9iRYMkZ
 iVlwSNRmZQ95H18qeisYHLebBrXpIrhJw18Oaw6g7myc2L00Zk
 RuxAxvp0nt4J5rOsE9EcjIX58g+VbuBLcOdCvgJWhBIYbvpVdp
 Bu4AlXsr1H4gqoieKXK8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 May 2013 23:04:07 Chao Xie wrote:
> Now pxa27x-keypad make use matrix_keymap for matrix keyes, so
> remove the unused members in platform data.
> 
> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---
>  include/linux/platform_data/keypad-pxa27x.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/platform_data/keypad-pxa27x.h b/include/linux/platform_data/keypad-pxa27x.h
> index 0db423b..2462556 100644
> --- a/include/linux/platform_data/keypad-pxa27x.h
> +++ b/include/linux/platform_data/keypad-pxa27x.h
> @@ -39,8 +39,6 @@ struct pxa27x_keypad_platform_data {
>         const struct matrix_keymap_data *matrix_keymap_data;
>         unsigned int    matrix_key_rows;
>         unsigned int    matrix_key_cols;
> -       unsigned int    *matrix_key_map;
> -       int             matrix_key_map_size;
>  
>         /* direct keys */
>         int             direct_key_num;


This just broke a number of configurations:

em_x270_defconfig
ezx_defconfig
palmz72_defconfig
pxa3xx_defconfig

You have to make sure that all these board files get converted:

arch/arm/mach-pxa/em-x270.c
arch/arm/mach-pxa/ezx.c
arch/arm/mach-pxa/littleton.c
arch/arm/mach-pxa/mainstone.c
arch/arm/mach-pxa/mioa701.c
arch/arm/mach-pxa/palmld.c
arch/arm/mach-pxa/palmt5.c
arch/arm/mach-pxa/palmtreo.c
arch/arm/mach-pxa/palmtx.c
arch/arm/mach-pxa/palmz72.c
arch/arm/mach-pxa/tavorevb.c
arch/arm/mach-pxa/z2.c
arch/arm/mach-pxa/zylonite.c

or leave the code to interpret that platform data in place.

	Arnd
