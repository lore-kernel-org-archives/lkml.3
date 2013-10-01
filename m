Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3JAWCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:02:53 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41951 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab3JAWCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:02:48 -0400
Date: Tue, 1 Oct 2013 17:02:44 -0500
From: Kim Phillips <kim.phillips@linaro.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, a.motakis@virtualopensystems.com,
        agraf@suse.de, alex.williamson@redhat.com, stuart.yoder@freescale.com,
        B07421@freescale.com, B16395@freescale.com, R65777@freescale.com,
        peter.maydell@linaro.org, christoffer.dall@linaro.org,
        santosh.shukla@linaro.org, kvm@vger.kernel.org
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
Message-Id: <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
In-Reply-To: <20131001200054.GA27330@kroah.com>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
	<20131001200054.GA27330@kroah.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013 13:00:54 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Tue, Oct 01, 2013 at 01:38:31PM -0500, Kim Phillips wrote:
> > Hi,
> > 
> > Santosh and I are having a problem figuring out how to enable binding
> > (and re-binding) platform devices to a platform VFIO driver (see
> > Antonis' WIP: [1]) in an upstream-acceptable manner.
> > 
> > Binding platform drivers currently depends on a string match in the
> > device node's compatible entry.  On an arndale, one can currently
> > rebind the same device to the same driver like so:
> > 
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/bind
> > 
> > And one can bind it to the vfio-dt driver, as Antonis instructs, by
> > appending a 'vfio-dt' string to the device tree compatible entry for
> > the device.  Then this would work:
> > 
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-dt/bind
> > 
> > Consequently, the hack patch below [2] allows any platform device to be
> > bound to the vfio-dt driver, without making changes to the device
> > tree.  It's a hack because I don't see having any driver name specific
> > code in drivers/base/bus.c being upstream acceptable.
> 
> You are correct.
> 
> What is wrong with just doing the above unbind/bind things through
> sysfs, that is what it is there for, right?

The bind fails because the compatible string in the device tree doesn't
match that of the VFIO platform driver, so driver_match_device always
returns false.

Kim
