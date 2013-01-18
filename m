Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3ARXoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:44:04 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38557 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018Ab3ARXoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:44:02 -0500
X-Sasl-enc: bY5Pz6QHvx3blm9nY6EpnTji1I2FaJ4Adx0IhQDzGdwH 1358552641
Date: Fri, 18 Jan 2013 15:43:59 -0800
From: Greg KH <greg@kroah.com>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, neil.yi@huawei.com, wangyuhua@huawei.com,
        huqiao36@huawei.com, balbi@ti.com, mdharm-usb@one-eyed-alien.net,
        sebastian@breakpoint.cc
Subject: Re: USB: storage: optimize the matching rules and support new switch
 command for Huawei USB storage devices
Message-ID: <20130118234359.GA2160@kroah.com>
References: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:55:48AM +0800, fangxiaozhi 00110321 wrote:
> 
> From: fangxiaozhi <huananhu@huawei.com>
> 
> 1. Optimize the matching rules with new macro for Huawei USB storage
>    devices, to avoid to load USB storage driver for the modem interface
>    with Huawei devices.
> 2. Add to support new switch command for new Huawei USB dongles.
> 
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>

This patch breaks the build, did you test it out?

I get the following errors:

drivers/usb/storage/unusual_devs.h:1530:1: error: implicit declaration of function ‘UNUSUAL_VENDOR_INTF’ [-Werror=implicit-function-declaration]
drivers/usb/storage/unusual_devs.h:1534:3: warning: missing braces around initializer [-Wmissing-braces]
drivers/usb/storage/unusual_devs.h:1534:3: warning: (near initialization for ‘us_unusual_dev_list[186]’) [-Wmissing-braces]
drivers/usb/storage/unusual_devs.h:1534:3: error: initializer element is not constant
drivers/usb/storage/unusual_devs.h:1534:3: error: (near initialization for ‘us_unusual_dev_list[186].vendorName’)
drivers/usb/storage/unusual_devs.h:1537:1: warning: braces around scalar initializer [enabled by default]

And it goes on and on...

Care to fix this up and resend it?

thanks,

greg k-h
