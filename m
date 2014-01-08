Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbaAHNG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:06:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18478 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbaAHNGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:06:25 -0500
Date: Wed, 8 Jan 2014 16:03:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Roger Tseng <rogerable@realtek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wei_wang <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140108130305.GQ30234@mwanda>
References: <1387792327-2511-1-git-send-email-rogerable@realtek.com>
 <1387792327-2511-2-git-send-email-rogerable@realtek.com>
 <20140102094750.GZ28413@mwanda>
 <1121E117AD4ECE49880A389A396215BB939A5BD715@rtitmbs7.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1121E117AD4ECE49880A389A396215BB939A5BD715@rtitmbs7.realtek.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 03:56:05PM +0800, Roger Tseng wrote:
> Hi Dan,
> 
> >> +int rtsx_usb_ep0_write_register(struct rtsx_ucr *ucr, u16 addr,
> >> +             u8 mask, u8 data)
> >> +{
> >> +     u16 value = 0, index = 0;
> >> +
> >> +     value |= (u16)(3 & 0x03) << 14;
> >> +     value |= (u16)(addr & 0x3FFF);
> >
> >Don't do pointless things:
> >
> >        value |= 0x03 << 14;
> >        value |= addr & 0x3FFF;
> >
> >> +     value = ((value << 8) & 0xFF00) | ((value >> 8) & 0x00FF);
> >
> >This is an endian conversion?  It is buggy.  Use the kernel endian
> >conversion functions cpu_to_le16().
> 
> This is not a conversion for endianess with respect to CPU but for
> command format  of the device. It should always be performed
> regardless of platform.
> 
> In other words, it could be equivalent to:
>         value |= 0x03 << 6; // lower byte
>         value |= (addr & 0x3F00) >> 8; // lower byte
>         value |= (addr & 0xFF) << 8; //higher byte
> 
> We think the previous form is easier to read. Should we keep it or
> change to the later one?

To me it's really weird that the standard would specify that the address
is in byte swapped reversed CPU-endian order.  But if that's what it
says then I don't care about formatting details.  The original code is
fine.

regards,
dan carpenter
