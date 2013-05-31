Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3EaU1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:27:32 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:53104 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3EaU11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:27:27 -0400
Message-ID: <51A907B2.1070400@cogentembedded.com>
Date: Sat, 01 Jun 2013 00:27:30 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Emil Goode <emilgoode@gmail.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] usb: musb: Fix format specifier warning
References: <1370031778-25965-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1370031778-25965-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/01/2013 12:22 AM, Emil Goode wrote:

> This patch fixes a format specifier warning. dma_addr_t can be either
> u32 or u64 so we should cast to the largest type and change the format
> specifier to %llx.
> The addition of urb->transfer_dma and urb->actual_length is also done a
> few lines below. I have moved this code up and pass the variable buf to
> dev_dbg.
>
> Sparse output:
> drivers/usb/musb/musb_host.c:1761:4: warning:
> 	format ‘%x’ expects argument of type ‘unsigned int’,
> 	but argument 6 has type ‘dma_addr_t’ [-Wformat]
>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>   drivers/usb/musb/musb_host.c |   11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
> index 094cf80..d647ccb 100644
> --- a/drivers/usb/musb/musb_host.c
> +++ b/drivers/usb/musb/musb_host.c
[...]
> @@ -1789,11 +1789,8 @@ void musb_host_rx(struct musb *musb, u8 epnum)
>   					length = rx_count;
>   				d->status = d_status;
>   				buf = urb->transfer_dma + d->offset;
> -			} else {
> +			} else

    You should keep {} on the *else* branch since *if* branch has {},
according to Documentation/CodingStyle.

>   				length = rx_count;
> -				buf = urb->transfer_dma +
> -						urb->actual_length;
> -			}

WBR, Sergei


