Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628Ab3EBVXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:23:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:46931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3EBVXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:23:40 -0400
Message-ID: <5182D93C.4000706@infradead.org>
Date: Thu, 02 May 2013 14:23:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        =?UTF-8?B?RXplcXVpZWwgR2Fy?= =?UTF-8?B?Y8OtYQ==?= 
	<elezegarcia@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for May 1 (media/usb/stk1160)
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au> <518157EB.3010700@infradead.org> <51827DB1.7000304@redhat.com>
In-Reply-To: <51827DB1.7000304@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/13 07:52, Mauro Carvalho Chehab wrote:
> [media] stk1160: Make stk1160 module if SND is m and audio support is selected
> 
> As reported by Randy:
> 
> When CONFIG_SND=m and CONFIG_SND_AC97_CODEC=m and
> CONFIG_VIDEO_STK1160=y
> CONFIG_VIDEO_STK1160_AC97=y
> 
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x122706): undefined reference to `snd_card_create'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x1227b2): undefined reference to `snd_ac97_bus'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x1227cd): undefined reference to `snd_card_free'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x12281b): undefined reference to `snd_ac97_mixer'
> drivers/built-in.o: In function `stk1160_ac97_register':
> (.text+0x122832): undefined reference to `snd_card_register'
> drivers/built-in.o: In function `stk1160_ac97_unregister':
> (.text+0x12285e): undefined reference to `snd_card_free'
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> 
> diff --git a/drivers/media/usb/stk1160/Kconfig b/drivers/media/usb/stk1160/Kconfig
> index 1c3a1ec..2bf6392 100644
> --- a/drivers/media/usb/stk1160/Kconfig
> +++ b/drivers/media/usb/stk1160/Kconfig
> @@ -1,8 +1,6 @@
> -config VIDEO_STK1160
> +config VIDEO_STK1160_COMMON
>      tristate "STK1160 USB video capture support"
>      depends on VIDEO_DEV && I2C
> -    select VIDEOBUF2_VMALLOC
> -    select VIDEO_SAA711X
>  
>      ---help---
>        This is a video4linux driver for STK1160 based video capture devices.
> @@ -12,9 +10,14 @@ config VIDEO_STK1160
>  
>  config VIDEO_STK1160_AC97
>      bool "STK1160 AC97 codec support"
> -    depends on VIDEO_STK1160 && SND
> -    select SND_AC97_CODEC
> -
> +    depends on VIDEO_STK1160_COMMON && SND
>      ---help---
>        Enables AC97 codec support for stk1160 driver.
> -.
> +
> +config VIDEO_STK1160
> +    tristate
> +    depends on (!VIDEO_STK1160_AC97 || (SND='n') || SND) && VIDEO_STK1160_COMMON
> +    default y
> +    select VIDEOBUF2_VMALLOC
> +    select VIDEO_SAA711X
> +    select SND_AC97_CODEC if SND
> 
> 
> -- 


-- 
~Randy
