Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaIYLCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:02:32 -0400
Received: from mail.schreyben.de ([176.9.239.78]:42321 "EHLO mail.schreyben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaIYLCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:02:30 -0400
Message-ID: <5423F644.50707@schreyben.de>
Date: Thu, 25 Sep 2014 13:02:28 +0200
From: Schrey <debian-kernel@schreyben.de>
Organization: unorganised, like, totally.
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: linux-stable: backport usb related commit to 3.10 and 3.12?
References: <53F878AD.1000408@schreyben.de>
In-Reply-To: <53F878AD.1000408@schreyben.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

resending; multiple systems are and have been working fine
for me, with that commit backported to kernel 3.10 and 3.12.

2014-08-23:
> Greetings.
>
> On an administered server, I noticed that there's a constant load
> around 0.70 when running kernels 3.10 and 3.12, even if
> the system is doing nothing, and in single user mode.
> Culprit seems to be the process 'khubd'.
> No such effect when running kernels 3.4 or 3.14.
>
> I reverse bisected linux-stable and found that the following commit
> fixes it for me, for both kernel 3.10 and 3.12:
>
> [08d1dec6f4054e3613f32051d9b149d4203ce0d2] usb:hub set 
> hub->change_bits when over-current happens
>
>
> Could that commit be backported to the stable 3.10 and 3.12 series?
>
> (Disclaimer: I'm not a programmer, but I'd be happy to help with any 
> testing involved)
>
> Regards
> Ingmar
>
> -------------------------------------------------------------------------- 
>
>
> $ git diff ac5166bcdb43889a5bd837f5076b78049e1f8bca 
> 08d1dec6f4054e3613f32051d9b149d4203ce0d2
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index c1422a0..babba88 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1147,7 +1147,8 @@ static void hub_activate(struct usb_hub *hub, 
> enum hub_activation_type type)
>                         /* Tell khubd to disconnect the device or
>                          * check for a new connection
>                          */
> -                       if (udev || (portstatus & 
> USB_PORT_STAT_CONNECTION))
> +                       if (udev || (portstatus & 
> USB_PORT_STAT_CONNECTION) ||
> +                           (portstatus & USB_PORT_STAT_OVERCURRENT))
>                                 set_bit(port1, hub->change_bits);
>
>                 } else if (portstatus & USB_PORT_STAT_ENABLE) {
>
>


-- 
this space for rent

