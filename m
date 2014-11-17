Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaKQPVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:21:43 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:51474 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaKQPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:21:42 -0500
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <849f4721a3a2bc2d05a833ec688a1efc>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <546A1276.2070102@rock-chips.com>
Date: Mon, 17 Nov 2014 23:21:26 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>
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

This patch is no complete, Sorry for that, I will upload a new version 
tomorrow.

- Kever

On 11/17/2014 09:14 PM, Kever Yang wrote:
> After we implement the bus_suspend/resume, auto suspend id enabled.
> The root hub will be auto suspend if there is no device connected,
> we need to resume the root hub when a device connect detect.
>
> This patch tested on rk3288.
>
> Signed-off-by: Roy Li <roy.li@rock-chips.com>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
>   drivers/usb/dwc2/hcd_intr.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
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
> +			usb_hcd_resume_root_hub(hcd);
> +
> +		/*
>   		 * The Hub driver asserts a reset when it sees port connect
>   		 * status change flag
>   		 */

