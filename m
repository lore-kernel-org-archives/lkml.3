Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3DWUEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:04:37 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:46120 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3DWUEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:04:36 -0400
Message-ID: <5176E927.908@cogentembedded.com>
Date: Wed, 24 Apr 2013 00:03:51 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 04/10] usb: musb: ux500: harden checks for platform data
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org> <1366729394-11406-5-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366729394-11406-5-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04/23/2013 07:03 PM, Lee Jones wrote:

> In its current state, the ux500-musb driver uses platform data pointers
> blindly with no prior checking. If no platform data pointer is passed
> this will Oops the kernel. In this patch we ensure platform data and
> board data are present prior to using them.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/usb/musb/ux500_dma.c |   11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
> index c75e07a..02b4a6e 100644
> --- a/drivers/usb/musb/ux500_dma.c
> +++ b/drivers/usb/musb/ux500_dma.c
> @@ -287,7 +287,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
>   	struct musb *musb = controller->private_data;
>   	struct device *dev = musb->controller;
>   	struct musb_hdrc_platform_data *plat = dev->platform_data;
> -	struct ux500_musb_board_data *data = plat->board_data;
> +	struct ux500_musb_board_data *data;
>   	struct dma_channel *dma_channel = NULL;
>   	u32 ch_num;
>   	u8 dir;
> @@ -297,14 +297,19 @@ static int ux500_dma_controller_start(struct dma_controller *c)

[...]

>   
>   	/* Prepare the loop for RX channels */
>   	channel_array = controller->rx_channel;
> -	param_array = data->dma_rx_param_array;
> +	param_array = (data) ? data->dma_rx_param_array : NULL;

    Why enclose a simple variable in parens?

>   
>   	for (dir = 0; dir < 2; dir++) {
>   		for (ch_num = 0;
> @@ -337,7 +342,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
>   
>   		/* Prepare the loop for TX channels */
>   		channel_array = controller->tx_channel;
> -		param_array = data->dma_tx_param_array;
> +		param_array = (data) ? data->dma_tx_param_array : NULL;

    Again, why?

WBR, Sergei

