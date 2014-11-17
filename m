Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaKQSRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:17:04 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:37801 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaKQSRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:17:02 -0500
Message-ID: <546A3B93.1030900@cogentembedded.com>
Date: Mon, 17 Nov 2014 21:16:51 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kever Yang <kever.yang@rock-chips.com>,
        Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>
CC: Dinh Nguyen <dinguyen@opensource.altera.com>, romain.perier@gmail.com,
        Heiko Stuebner <heiko@sntech.de>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        wulf@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org, Roy Li <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: resume root hub when device detect with suspend
 state
References: <1416230077-17535-1-git-send-email-kever.yang@rock-chips.com>
In-Reply-To: <1416230077-17535-1-git-send-email-kever.yang@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/17/2014 04:14 PM, Kever Yang wrote:

> After we implement the bus_suspend/resume, auto suspend id enabled.
> The root hub will be auto suspend if there is no device connected,
> we need to resume the root hub when a device connect detect.

> This patch tested on rk3288.

> Signed-off-by: Roy Li <roy.li@rock-chips.com>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---

>   drivers/usb/dwc2/hcd_intr.c | 7 +++++++
>   1 file changed, 7 insertions(+)

> diff --git a/drivers/usb/dwc2/hcd_intr.c b/drivers/usb/dwc2/hcd_intr.c
> index 551ba87..c8299fd 100644
> --- a/drivers/usb/dwc2/hcd_intr.c
> +++ b/drivers/usb/dwc2/hcd_intr.c
> @@ -355,6 +355,13 @@ static void dwc2_port_intr(struct dwc2_hsotg *hsotg)
>   		hprt0_modify |= HPRT0_CONNDET;
>
>   		/*
> +		 * Check if root hub is in suspend state
> +		 * if root hub in suspend, resume it.
> +		 */
> +		if ((bus->root_hub) && (hcd->state == HC_STATE_SUSPENDED))

    Inner parens are not needed, especially the first ones.

[...]

WBR, Sergei

