Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3EHVS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:18:28 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63588 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3EHVSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:18:25 -0400
Date: Wed, 8 May 2013 23:18:19 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH -next] media/usb: fix kconfig dependencies (aka bool
 depending on tristate considered harmful)
Message-ID: <20130508211819.GF3413@free.fr>
References: <20130508140122.e4747b58be4333060b7a248a@canb.auug.org.au>
 <518A98D9.4020906@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <518A98D9.4020906@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy, All,

On Wed, May 08, 2013 at 11:26:33AM -0700, Randy Dunlap wrote:
> (a.k.a. Kconfig bool depending on a tristate considered harmful)

Maybe that would warrant a bit of explanations in:
    Documentation/kbuild/kconfig-language.txt

> Fix various build errors when CONFIG_USB=m and media USB drivers
> are builtin.  In this case, CONFIG_USB_ZR364XX=y,
> CONFIG_VIDEO_PVRUSB2=y, and CONFIG_VIDEO_STK1160=y.
> 
> This is caused by (from drivers/media/usb/Kconfig):
> 
> menuconfig MEDIA_USB_SUPPORT
> 	bool "Media USB Adapters"
> 	depends on USB && MEDIA_SUPPORT
> 	           =m     =y
> so MEDIA_USB_SUPPORT=y and all following Kconfig 'source' lines
> are included.  By adding an "if USB" guard around the 'source' lines,
> the needed dependencies are enforced.
[--SNIP--]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  drivers/media/usb/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-next-20130508.orig/drivers/media/usb/Kconfig
> +++ linux-next-20130508/drivers/media/usb/Kconfig
> @@ -5,6 +5,7 @@ menuconfig MEDIA_USB_SUPPORT
>  	  Enable media drivers for USB bus.
>  	  If you have such devices, say Y.
>  
> +if USB
>  if MEDIA_USB_SUPPORT

Why not starting the 'if USB' block just above MEDIA_USB_SUPPORT, and
removing the 'depends on USB' from MEDIA_USB_SUPPORT :

---8<--- 
if USB
menuconfig MEDIA_USB_SUPPORT
    bool "Media USB Adapters"
    depends on MEDIA_SUPPORT

if MEDIA_USB_SUPPORT
---8<--- 

And keeping this hunk as-is:
> @@ -52,3 +53,4 @@ source "drivers/media/usb/em28xx/Kconfig
>  endif
>  
>  endif #MEDIA_USB_SUPPORT
> +endif #USB

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
