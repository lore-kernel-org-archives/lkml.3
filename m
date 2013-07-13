Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3GMB3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 21:29:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984Ab3GMB3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 21:29:03 -0400
Date: Fri, 12 Jul 2013 18:30:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] misc: add driver for Renesas R-Car Gyro-ADC/speed-pulse
 interfaces
Message-ID: <20130713013000.GA22493@kroah.com>
References: <201307130351.42967.sergei.shtylyov@cogentembedded.com>
 <20130713005702.GA14788@kroah.com>
 <51E0AA24.6070203@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E0AA24.6070203@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 05:15:16AM +0400, Sergei Shtylyov wrote:
> Hello.
> 
>    Can't get to sleep, sigh...
> 
> On 07/13/2013 04:57 AM, Greg KH wrote:
> 
> >>Add the driver for Gyro-ADC/speed-pulse interfaces found in Renesas R-Car SoCs.
> >>Though  being two separate devices, they have to be driven together because of
> >>the shared start/stop register (located in Gyro-ADC still). At this time, only
> >>speed-pulse interface is fully supported, the Gyro-ADC is just initialized and
> >>started/stopped synchronously with the speed-pulse interface.  A user interface
> >>is implemented via several sysfs files which allow to read and reset the speed-
> >>pulse interface's registers.
> 
> >If you modify/create/remove sysfs files, you also have to document them
> >in Documentation/ABI/ which is missing from this patch.
> 
>    I've looked there and didn't find the documentation for my closest
> model driver, drivers/misc/ti_dac7512.c (or for many other drivers),
> so I thought I too can do without it.

Nope, that driver should be fixed as well, care to do so?

> >Your sysfs files are also being created in a "racy" way, i.e. after
> >userspace is told about the device, please fix that as well.
> 
>    Not sure I understand you. Could you elaborate?

Please read the driver model documentation, it goes into the details of
how to do this properly.  As does this post from me a week or so ago:
	http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/

greg k-h
