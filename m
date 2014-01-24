Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaAXRwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:52:55 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:29349 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaAXRww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:52:52 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-1c-52e2a873d584
Message-id: <52E2A86E.1000804@samsung.com>
Date: Fri, 24 Jan 2014 10:52:46 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>,
        "thomas.pugliese@gmail.com >> Thomas Pugliese" 
	<thomas.pugliese@gmail.com>
Subject: Re: [PATCH] staging/usbip: Change userspace to use linux include for
 usb_device_speed enum
References: <1390413372-3451-1-git-send-email-shuah.kh@samsung.com>
In-reply-to: <1390413372-3451-1-git-send-email-shuah.kh@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.10]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9hP93iFY+CDB53c1nsOfOL3aJ58Xo2
	i8u75rBZLFrWymzx7FqOxdefDhZfJr1kc2D3WHLhDpPHvX2HWTx2zrrL7rF/7hp2j8+b5AJY
	o7hsUlJzMstSi/TtErgyru7/wFpwnLfi1eQOpgbGm1xdjJwcEgImEnMuPmaGsMUkLtxbz9bF
	yMUhJLCMUeL/8Z3sEE4vk0TvgvUsEM4mRokzD1exg7TwCmhJbDgzA6idg4NFQFVixRRukDCb
	gLrE59c7wEqEBOQkmpasBtsgKhAh8ersRBaIVkGJH5PvsYC0igiYSUzbVg8ynlmghUni1Ll/
	TCBxYYFUiRWnOSDGOEu8u7GOCcTmFHCReP5rBSuIzSxgLbFy0jZGCFteYvOat8wQ9coSfy6f
	AhsjIaAo8eKh1QRGkVlIFs9C0j0LSfcCRuZVjGKlxckFxUnpqRVGesWJucWleel6yfm5mxgh
	EVS9g/HuV5tDjAIcjEo8vB+CHwYJsSaWFVfmHmKU4GBWEuGtXPooSIg3JbGyKrUoP76oNCe1
	+BAjEwenVAOj88kt3zlutVkJ5t/ZP/Ha4jOBe28vyCz30dD5oeF+Zr6nM9s+w2SzoJIddizh
	li9nJIWWm7HNd1E2/Lbv+YOiWGejKctvtGtP+tvOaxTI2B1V8TUj4F+EjEB7+eueKaob3Bdw
	3Kw8Y6F+8tXDXLF9WooBx8SbJ2ROeOHpKFIaHCdy/eIi0UdKLMUZiYZazEXFiQBQzzznfgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 10:56 AM, Shuah Khan wrote:
> Remove usb_device_speed enum define from usbip_common.h and change it to
> include linux/usb/ch9.h instead.
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>   drivers/staging/usbip/userspace/libsrc/usbip_common.h | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
> index 938ad1c..2cb81b3 100644
> --- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
> +++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
> @@ -14,6 +14,7 @@
>
>   #include <syslog.h>
>   #include <unistd.h>
> +#include <linux/usb/ch9.h>
>
>   #ifndef USBIDS_FILE
>   #define USBIDS_FILE "/usr/share/hwdata/usb.ids"
> @@ -76,13 +77,6 @@ extern int usbip_use_debug ;
>   		abort();				\
>   	} while (0)
>
> -enum usb_device_speed {
> -	USB_SPEED_UNKNOWN = 0,                  /* enumerating */
> -	USB_SPEED_LOW, USB_SPEED_FULL,          /* usb 1.1 */
> -	USB_SPEED_HIGH,                         /* usb 2.0 */
> -	USB_SPEED_VARIABLE                      /* wireless (usb 2.5) */
> -};
> -
>   /* FIXME: how to sync with drivers/usbip_common.h ? */
>   enum usbip_device_status {
>   	/* sdev is available. */
>

I just realized the following two userspace patches should be combined 
or sent as a series. I will send them together addressing Thomas 
Pugliese's review comments.

https://lkml.org/lkml/2014/1/22/336
https://lkml.org/lkml/2014/1/22/420

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
