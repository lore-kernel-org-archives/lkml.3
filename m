Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaGNL6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:58:13 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26288 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbaGNL55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:57:57 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-77-53c3c5c3f5db
Message-id: <53C3C5C2.1020300@samsung.com>
Date: Mon, 14 Jul 2014 13:57:54 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Joonyoung Shim <jy0922.shim@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, broonie@linaro.org, tobetter@gmail.com
Subject: Re: [PATCH 2/2] USB: add reset resume quirk for usb3503
References: <1404969755-30555-1-git-send-email-jy0922.shim@samsung.com>
 <1404969755-30555-2-git-send-email-jy0922.shim@samsung.com>
In-reply-to: <1404969755-30555-2-git-send-email-jy0922.shim@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xy7qHjx4ONphxQMhi0/XrrBbNi9ez
	Wby4d5HF4vKuOWwWi5a1Mlvse7yG2YHNY+esu+wed67tYfPYP3cNu0ffllWMHp83yQWwRnHZ
	pKTmZJalFunbJXBltKz4zVawnL/i6/FpLA2MM3m6GDk5JARMJI79OMkCYYtJXLi3nq2LkYtD
	SGApo8TxCzeZIZxPjBInP3YxdjFycPAKaEkc+lQE0sAioCrx+NFnVhCbTcBQouttFxuILSoQ
	I3Gm9zMziM0rICjxY/I9sAUiAukSz//tZAcZwyzgJnHqihZIWFjAQeL+QZAwyKpWRonLP18w
	gdRwCnhINB12BqlhFjCTeNSyjhnClpfYvOYt8wRGgVlINsxCUjYLSdkCRuZVjKKppckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGCGB/WUH4+JjVocYBTgYlXh4K8QOBwuxJpYVV+YeYpTgYFYS4Q0/
	CBTiTUmsrEotyo8vKs1JLT7EyMTBKdXAmOK36tuEjkVH3LZ8Pd8Q8PWYgfeyj48XuYn0P9Zu
	zdT5LmFzKsvr+h4hsXvv/yhGPnB9OPHd/No+eVFbb6ecE+1X7zbNOMIeMsHzseTz/bxbqwRs
	P0l8dVuW8lQ/+vnOpVVbmTYenPNCXWXfmsU87xLezYqeH37G4G/zlE22fDwWKxcJSJ5Z+0yJ
	pTgj0VCLuag4EQDGXwwWSgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-07-10 07:22, Joonyoung Shim wrote:
> The usb device will autoresume from choose_wakeup() if it is
> autosuspended with the wrong wakeup setting, but below errors occur
> because usb3503 misc driver will switch to standby mode when suspended.
>
> As add USB_QUIRK_RESET_RESUME, it can stop setting wrong wakeup from
> autosuspend_check().
>
> [    7.734717] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
> [    7.854658] usb 1-3: device descriptor read/64, error -71
> [    8.079657] usb 1-3: device descriptor read/64, error -71
> [    8.294664] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
> [    8.414658] usb 1-3: device descriptor read/64, error -71
> [    8.639657] usb 1-3: device descriptor read/64, error -71
> [    8.854667] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
> [    9.264598] usb 1-3: device not accepting address 3, error -71
> [    9.374655] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
> [    9.784601] usb 1-3: device not accepting address 3, error -71
> [    9.784838] usb usb1-port3: device 1-3 not suspended yet
>
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/usb/core/quirks.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
> index 739ee8e..2c9ba407 100644
> --- a/drivers/usb/core/quirks.c
> +++ b/drivers/usb/core/quirks.c
> @@ -152,6 +152,9 @@ static const struct usb_device_id usb_quirk_list[] = {
>   	/* INTEL VALUE SSD */
>   	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
>   
> +	/* USB3503 */
> +	{ USB_DEVICE(0x0424, 0x3503), .driver_info = USB_QUIRK_RESET_RESUME },
> +
>   	{ }  /* terminating entry must be last */
>   };
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

