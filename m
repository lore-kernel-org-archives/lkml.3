Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbaDVM2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:28:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33402 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415AbaDVM2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:28:49 -0400
Message-ID: <53566078.1070602@ti.com>
Date: Tue, 22 Apr 2014 15:28:40 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bigeasy@linutronix.de>, <sergei.shtylyov@cogentembedded.com>,
        "3.9+" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: gadget: zero: Fix SuperSpeed enumeration for
 alternate setting 1
References: <1395826086-5097-1-git-send-email-rogerq@ti.com> <1395852398-7578-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1395852398-7578-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 03/26/2014 06:46 PM, Roger Quadros wrote:
> It was impossible to enumerate on a SuperSpeed (XHCI) host
> with alternate setting = 1 due to the wrongly set 'bMaxBurst'
> field in the SuperSpeed Endpoint Companion descriptor.
> 
> Testcase:
> <host> modprobe -r usbtest; modprobe usbtest alt=1
> <device> modprobe g_zero
> plug device to SuperSpeed port on the host.
> 
> Without this patch the host always complains like so
> "usb 12-2: Not enough bandwidth for new device state.
>  usb 12-2: Not enough bandwidth for altsetting 1"
> 
> Bug was introduced by commit cf9a08ae in v3.9
> 
> Fixes: cf9a08ae5aec (usb: gadget: convert source sink and loopback to
> new function interface)
> 
> Cc: 3.9+ <stable@vger.kernel.org> # 3.9+
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Can you please queue this for -rc fixes? Thanks.

cheers,
-roger

> ---
>  drivers/usb/gadget/zero.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
> index 9f170c5..134f354 100644
> --- a/drivers/usb/gadget/zero.c
> +++ b/drivers/usb/gadget/zero.c
> @@ -300,7 +300,7 @@ static int __init zero_bind(struct usb_composite_dev *cdev)
>  	ss_opts->isoc_interval = gzero_options.isoc_interval;
>  	ss_opts->isoc_maxpacket = gzero_options.isoc_maxpacket;
>  	ss_opts->isoc_mult = gzero_options.isoc_mult;
> -	ss_opts->isoc_maxburst = gzero_options.isoc_maxpacket;
> +	ss_opts->isoc_maxburst = gzero_options.isoc_maxburst;
>  	ss_opts->bulk_buflen = gzero_options.bulk_buflen;
>  
>  	func_ss = usb_get_function(func_inst_ss);
> 

