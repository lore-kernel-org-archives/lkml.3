Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab3LEPKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:10:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60601 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751247Ab3LEPKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:10:17 -0500
Date: Thu, 5 Dec 2013 10:10:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Yijing Wang <wangyijing@huawei.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 1/2] usb: Use dev_is_pci() to check whether it is pci
 device
In-Reply-To: <1386242492-25480-1-git-send-email-wangyijing@huawei.com>
Message-ID: <Pine.LNX.4.44L0.1312051009520.1311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Yijing Wang wrote:

> Use PCI standard marco dev_is_pci() instead of directly compare
> pci_bus_type to check whether it is pci device.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/usb/host/ehci-dbg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
> index 4a9c2ed..0bb5e48 100644
> --- a/drivers/usb/host/ehci-dbg.c
> +++ b/drivers/usb/host/ehci-dbg.c
> @@ -818,7 +818,7 @@ static ssize_t fill_registers_buffer(struct debug_buffer *buf)
>  
>  #ifdef	CONFIG_PCI
>  	/* EHCI 0.96 and later may have "extended capabilities" */
> -	if (hcd->self.controller->bus == &pci_bus_type) {
> +	if (dev_is_pci(hcd->self.controller)) {
>  		struct pci_dev	*pdev;
>  		u32		offset, cap, cap2;
>  		unsigned	count = 256/4;

Acked-by: Alan Stern <stern@rowland.harvard.edu>

