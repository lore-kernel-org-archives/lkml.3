Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab3HOQfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:35:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086Ab3HOQfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:35:31 -0400
Date: Thu, 15 Aug 2013 09:37:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        dmitry.kasatkin@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] dev-core: fix build break when DEBUG is enabled
Message-ID: <20130815163705.GA15688@kroah.com>
References: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 07:04:54PM +0300, Dmitry Kasatkin wrote:
> When DEBUG is defined, dev_dbg_ratelimited uses dynamic debug data
> structures even when CONFIG_DYNAMIC_DEBUG is not defined.
> It leads to build break.
> For example, when I try to use dev_dbg_ratelimited in USB code and
> CONFIG_USB_DEBUG is enabled, but CONFIG_DYNAMIC_DEBUG is not, I get:
> 
>   CC [M]  drivers/usb/host/xhci-ring.o
>   drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_intr_tx’:
>   drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘DEFINE_DYNAMIC_DEBUG_METADATA’ [-Werror=implicit-function-declaration]
>   drivers/usb/host/xhci-ring.c:3059:3: error: ‘descriptor’ undeclared (first use in this function)
>   drivers/usb/host/xhci-ring.c:3059:3: note: each undeclared identifier is reported only once for each function it appears in
>   drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘__dynamic_pr_debug’ [-Werror=implicit-function-declaration]
>   drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_isoc_tx_prepare’:
>   drivers/usb/host/xhci-ring.c:3847:3: error: ‘descriptor’ undeclared (first use in this function)
>   cc1: some warnings being treated as errors
>   make[2]: *** [drivers/usb/host/xhci-ring.o] Error 1
>   make[1]: *** [drivers/usb/host] Error 2
>   make: *** [drivers/usb/] Error 2
> 
> This patch separates definition for CONFIG_DYNAMIC_DEBUG and DEBUG cases.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Cc: stable@vger.kernel.org

How is this a stable issue?  I don't see how the rules listed in
Documentation/stable_kernel_rules.txt apply here, what am I missing?

Not to say your patch isn't correct, just that it's not stable material,
right?

thanks,

greg k-h
