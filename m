Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3JAUAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:00:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3JAUAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:00:48 -0400
Date: Tue, 1 Oct 2013 13:00:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kim Phillips <kim.phillips@linaro.org>
Cc: linux-kernel@vger.kernel.org, a.motakis@virtualopensystems.com,
        Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        stuart.yoder@freescale.com, Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        santosh.shukla@linaro.org, kvm@vger.kernel.org
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
Message-ID: <20131001200054.GA27330@kroah.com>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 01:38:31PM -0500, Kim Phillips wrote:
> Hi,
> 
> Santosh and I are having a problem figuring out how to enable binding
> (and re-binding) platform devices to a platform VFIO driver (see
> Antonis' WIP: [1]) in an upstream-acceptable manner.
> 
> Binding platform drivers currently depends on a string match in the
> device node's compatible entry.  On an arndale, one can currently
> rebind the same device to the same driver like so:
> 
> echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/bind
> 
> And one can bind it to the vfio-dt driver, as Antonis instructs, by
> appending a 'vfio-dt' string to the device tree compatible entry for
> the device.  Then this would work:
> 
> echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-dt/bind
> 
> Consequently, the hack patch below [2] allows any platform device to be
> bound to the vfio-dt driver, without making changes to the device
> tree.  It's a hack because I don't see having any driver name specific
> code in drivers/base/bus.c being upstream acceptable.

You are correct.

What is wrong with just doing the above unbind/bind things through
sysfs, that is what it is there for, right?

greg k-h
