Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaATVRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:17:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaATVRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:17:30 -0500
Date: Mon, 20 Jan 2014 13:18:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roger <rogerable@realtek.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <cjb@laptop.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Wei_wang <wei_wang@realsil.com.cn>,
        "micky_ching@realsil.com.cn" <micky_ching@realsil.com.cn>
Subject: Re: [PATCH 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140120211817.GD634@kroah.com>
References: <1389685656-880-1-git-send-email-rogerable@realtek.com>
 <1389685656-880-2-git-send-email-rogerable@realtek.com>
 <20140114130409.GB11820@lee--X1>
 <52D79E31.6000300@realtek.com>
 <20140116093506.GI11820@lee--X1>
 <52DCE498.2010409@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DCE498.2010409@realtek.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 04:55:52PM +0800, Roger wrote:
> On 01/16/2014 05:35 PM, Lee Jones wrote:
> >>>>+static int rtsx_usb_bulk_transfer_sglist(struct rtsx_ucr *ucr,
> >>>>+             unsigned int pipe, struct scatterlist *sg, int num_sg,
> >>>>+             unsigned int length, unsigned int *act_len, int timeout)
> >>>>+{
> >>>>+     int ret;
> >>>>+
> >>>>+     dev_dbg(&ucr->pusb_intf->dev, "%s: xfer %u bytes, %d entries\n",
> >>>>+                     __func__, length, num_sg);
> >>>>+     ret = usb_sg_init(&ucr->current_sg, ucr->pusb_dev, pipe, 0,
> >>>>+                     sg, num_sg, length, GFP_NOIO);
> >>>>+     if (ret)
> >>>>+             return ret;
> >>>>+
> >>>>+     ucr->sg_timer.expires = jiffies + msecs_to_jiffies(timeout);
> >>>>+     add_timer(&ucr->sg_timer);
> >>>>+     usb_sg_wait(&ucr->current_sg);
> >>>>+     del_timer(&ucr->sg_timer);
> >>>>+
> >>>>+     if (act_len)
> >>>>+             *act_len = ucr->current_sg.bytes;
> >>>>+
> >>>>+     return ucr->current_sg.status;
> >>>>+}
> >>>
> >>>Code looks fine, but shouldn't this live in a USB driver?
> >>>
> >>We have studied drivers in usb/storage, the place that most likely
> >>to put the driver. All of them are for STANDARD usb mass storage
> >>class(something like USB_CLASS_MASS_STORAGE). But this is not the
> >>same case. This driver is for our vendor-class device with
> >>completely different protocol. It is really an USB interfaced flash
> >>card command converter(or channel) device rather than a real
> >>storage. It also has two derived modules(rtsx_usb_sdmmc,
> >>rtsx_usb_memstick) for other two subsystems.
> >>
> >>We also have another driver: rtsx_pcr.c resident in mfd/ for similar
> >>devices but of PCIe interface. It is nature for us to choose the
> >>same place for this variant.
> >
> >Very well, as long as it truly does not fit in drivers/usb. It would
> >be good to have one of the USB folk give the nod though.
> >
> I found Greg K-H is exactly one of the maintainers of USB subsystem as I
> read the MAINTAINERS document.
> 
> Greg, would you please comment this subsystem concern or introduce other
> members? Thanks.

It's the middle of the merge window, nothing can happen until after
3.14-rc1 is out.  So how about resending all of this in two weeks after
that happens so we can all properly discuss it?

As for where the driver should be located, if it shares logic with the
usb storage driver, then it should be in drivers/usb/storage, otherwise
put it wherever makes most sense, there's no need to put all USB drivers
under drivers/usb/ at all.

thanks,

greg k-h
