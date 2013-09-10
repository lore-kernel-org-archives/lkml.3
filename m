Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3IJI55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:57:57 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8586 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3IJI5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:57:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 10 Sep 2013 01:54:53 -0700
Message-ID: <522EE3B9.4020807@nvidia.com>
Date: Tue, 10 Sep 2013 14:47:45 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "kishon@ti.com" <kishon@ti.com>
Subject: Re: [PATCH] extcon: palmas: Dont set USB state if ID pin is grounded
References: <1378799369-15803-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1378799369-15803-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 September 2013 01:19 PM, George Cherian wrote:
> In OMAP5 when USB-HOST is set true, the VBUS regulator  is turned ON.
> This causes a VBUS interrupt, ignore the same if we are already in
> USB-HOST.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/extcon/extcon-palmas.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
> index 9672f31..91b31af 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -50,6 +50,9 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
>   	struct palmas_usb *palmas_usb = _palmas_usb;
>   	unsigned int vbus_line_state;
>   
> +	if (palmas_usb->linkstat == PALMAS_USB_STATE_ID)
> +		return IRQ_HANDLED;
> +

Should we really handle this on this extcon driver? I think it should be 
handled in the USB driver. If port is OTG type and if usb driver enable 
the VBUS then it can expect the VBUS available notification but based on 
the USB driver state, it should ignore this notification.

Otherwise, Palmas pin find that there is VBUS state true but the SW 
status will show as the VBUS not there.

