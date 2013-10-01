Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3JAWB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:01:28 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54699 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3JAWB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:01:27 -0400
Date: Tue, 1 Oct 2013 17:01:23 -0500
From: Kim Phillips <kim.phillips@linaro.org>
To: scottwood@freescale.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        a.motakis@virtualopensystems.com, agraf@suse.de,
        alex.williamson@redhat.com, stuart.yoder@freescale.com,
        B07421@freescale.com, B16395@freescale.com, R65777@freescale.com,
        peter.maydell@linaro.org, christoffer.dall@linaro.org,
        santosh.shukla@linaro.org, kvm@vger.kernel.org
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
Message-Id: <20131001170123.cfc27ce91abba60668eb50ad@linaro.org>
In-Reply-To: <1380655036.10618.32.camel@snotra.buserror.net>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
	<1380654938.10618.30.camel@snotra.buserror.net>
	<1380655036.10618.32.camel@snotra.buserror.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013 14:17:16 -0500
Scott Wood <scottwood@freescale.com> wrote:

> On Tue, 2013-10-01 at 14:15 -0500, Scott Wood wrote:
> > On Tue, 2013-10-01 at 13:38 -0500, Kim Phillips wrote:
> > > Hi,
> > > 
> > > Santosh and I are having a problem figuring out how to enable binding
> > > (and re-binding) platform devices to a platform VFIO driver (see
> > > Antonis' WIP: [1]) in an upstream-acceptable manner.
> > > 
> > > Binding platform drivers currently depends on a string match in the
> > > device node's compatible entry.  On an arndale, one can currently
> > > rebind the same device to the same driver like so:
> > > 
> > > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> > > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/bind
> > > 
> > > And one can bind it to the vfio-dt driver, as Antonis instructs, by
> > > appending a 'vfio-dt' string to the device tree compatible entry for
> > > the device.  Then this would work:
> > > 
> > > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> > > echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-dt/bind
> > > 
> > > Consequently, the hack patch below [2] allows any platform device to be
> > > bound to the vfio-dt driver, without making changes to the device
> > > tree.  It's a hack because I don't see having any driver name specific
> > > code in drivers/base/bus.c being upstream acceptable.
> > 
> > Modifying the device tree is the worse part of this.
> 
> I think I missed something.  How do you reconcile "without making
> changes to the device tree" with "appending a 'vfio-dt' string to the
> device tree compatible entry"?

one doesn't need to append 'vfio-dt' to the device tree compatibles if
one uses the hack that makes bind_store ignore trying to
driver_match_device() if the driver is 'vfio-dt'.

Kim
