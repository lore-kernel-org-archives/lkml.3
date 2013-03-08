Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3CHT5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:57:10 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:58930 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3CHT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:57:08 -0500
Message-ID: <513A426A.9060903@cogentembedded.com>
Date: Fri, 08 Mar 2013 23:56:26 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: oskar.andero@sonymobile.com
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Truls Bengtsson <truls.bengtsson@sonymobile.com>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Subject: Re: [RFC PATCH 1/1] usb: f_rndis: Avoid to use ERROR macro if cdev
 can be null
References: <1362747220-2204-1-git-send-email-oskar.andero@sonymobile.com> <1362747220-2204-2-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1362747220-2204-2-git-send-email-oskar.andero@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-03-2013 16:53, oskar.andero@sonymobile.com wrote:

> From: Truls Bengtsson <truls.bengtsson@sonymobile.com>

> The udc_irq service runs the isr_tr_complete_handler which in turn
> "nukes" the endpoints, including a call to rndis_response_complete,
> if appropriate. If the rndis_msg_parser fails here, an error will
> be printed using a dev_err call (through the ERROR() macro).

> However, if the usb cable was just disconnected the device (cdev)
> might not be available and will be null. Since the dev_err macro will
> dereference the cdev pointer we get a null pointer exception.

> Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> Signed-off-by: Truls Bengtsson <truls.bengtsson@sonymobile.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>   drivers/usb/gadget/f_rndis.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
> index 71beeb8..41b5ebd 100644
> --- a/drivers/usb/gadget/f_rndis.c
> +++ b/drivers/usb/gadget/f_rndis.c
> @@ -6,6 +6,7 @@
>    * Copyright (C) 2008 Nokia Corporation
>    * Copyright (C) 2009 Samsung Electronics
>    *                    Author: Michal Nazarewicz (mina86@mina86.com)
> + * Copyright (C) 2013 Sony Mobile Communications AB.

    Your change seems too insignificant to add a copyright.

WBR, Sergei

