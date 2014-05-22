Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaEVLj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:39:57 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46044 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaEVLjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:39:55 -0400
Message-ID: <537DE20E.9050706@cogentembedded.com>
Date: Thu, 22 May 2014 15:39:58 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
CC: gregkh@linuxfoundation.org, balbi@ti.com, zonque@gmail.com, b-liu@ti.com
Subject: Re: [PATCH v5 5/6] usb: musb: dsps: Add the sw_babble_control()
References: <1400740181-31213-1-git-send-email-george.cherian@ti.com> <1400740181-31213-6-git-send-email-george.cherian@ti.com>
In-Reply-To: <1400740181-31213-6-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-05-2014 10:29, George Cherian wrote:

> Add sw_babble_control() logic to differentiate between transient
> babble and real babble condition. Also add the SW babble control
> register definitions.

> Babble control register logic is implemented in the latest
> revision of AM335x.

> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/usb/musb/musb_dsps.c | 50 ++++++++++++++++++++++++++++++++++++++++++++
>   drivers/usb/musb/musb_regs.h |  7 +++++++
>   2 files changed, 57 insertions(+)

> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index f6f3087..868caf8 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
> @@ -536,6 +536,56 @@ static int dsps_musb_set_mode(struct musb *musb, u8 mode)
>   	return 0;
>   }
>
> +static int sw_babble_control(struct musb *musb)
> +{

    Doesn't gcc complain on this function being unused? I think you should 
have added this function along with the caller, not separately.

WBR, Sergei

