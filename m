Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab3GMA4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:56:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab3GMA4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:56:07 -0400
Date: Fri, 12 Jul 2013 17:57:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] misc: add driver for Renesas R-Car Gyro-ADC/speed-pulse
 interfaces
Message-ID: <20130713005702.GA14788@kroah.com>
References: <201307130351.42967.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307130351.42967.sergei.shtylyov@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 03:51:42AM +0400, Sergei Shtylyov wrote:
> Add the driver for Gyro-ADC/speed-pulse interfaces found in Renesas R-Car SoCs.
> Though  being two separate devices, they have to be driven together because of
> the shared start/stop register (located in Gyro-ADC still). At this time, only
> speed-pulse interface is fully supported, the Gyro-ADC is just initialized and
> started/stopped synchronously with the speed-pulse interface.  A user interface
> is implemented via several sysfs files which allow to read and reset the speed-
> pulse interface's registers.

If you modify/create/remove sysfs files, you also have to document them
in Documentation/ABI/ which is missing from this patch.

Your sysfs files are also being created in a "racy" way, i.e. after
userspace is told about the device, please fix that as well.

And are you sure you want to control this through sysfs?  There's no
other better user/kernel apis for it?

thanks,

greg k-h
