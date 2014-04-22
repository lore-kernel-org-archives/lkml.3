Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaDVNKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:10:07 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33607 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbaDVNJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:09:59 -0400
Message-ID: <53566A23.8010508@cogentembedded.com>
Date: Tue, 22 Apr 2014 17:09:55 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Felipe Balbi <balbi@ti.com>
CC: Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Tim Bird <tim.bird@sonymobile.com>
Subject: Re: [PATCH v6 15/19] usb: phy: msm: Fix PTS definitions for MSM USB
 controller
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com> <1398158438-21579-16-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1398158438-21579-16-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 22-04-2014 13:20, Ivan T. Ivanov wrote:

> From: Tim Bird <tbird20d@gmail.com>

> Fix the value used for Parallel Transceiver Select (PTS) for the MSM USB
> controller.  This is a standard chipidea PORTSC definition, where
> a PHY_TYPE of 10b (<<30) is ULPI and 11b (<<30) is SERIAL.
> Fix the definitions and use them correctly in the driver code.

> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> ---
>   drivers/usb/phy/phy-msm-usb.c    | 8 +++++---
>   include/linux/usb/msm_hsusb_hw.h | 5 +++--
>   2 files changed, 8 insertions(+), 5 deletions(-)

> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index dababf9..e83d13a 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -287,8 +287,9 @@ static int msm_link_reset(struct msm_otg *motg)
>   	if (motg->phy_number)
>   		writel(readl(USB_PHY_CTRL2) | BIT(16), USB_PHY_CTRL2);
>
> +	/* put transciever in serial mode as part of reset */

    s/transciever/transceiver/

[...]

> diff --git a/include/linux/usb/msm_hsusb_hw.h b/include/linux/usb/msm_hsusb_hw.h
> index 575c743..98d3dd8 100644
> --- a/include/linux/usb/msm_hsusb_hw.h
> +++ b/include/linux/usb/msm_hsusb_hw.h
> @@ -31,8 +31,9 @@
>   #define USB_USBINTR          (MSM_USB_BASE + 0x0148)
>
>   #define PORTSC_PHCD            (1 << 23) /* phy suspend mode */
> -#define PORTSC_PTS_MASK         (3 << 30)
> -#define PORTSC_PTS_ULPI         (3 << 30)
> +#define PORTSC_PTS_MASK        (3 << 30)
> +#define PORTSC_PTS_ULPI        (2 << 30)
> +#define PORTSC_PTS_SERIAL      (3 << 30)

    Please use tabs, not spaces here.

WBR, Sergei

