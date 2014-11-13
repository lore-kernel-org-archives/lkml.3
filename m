Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaKMKlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:41:35 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:49578 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbaKMKlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:41:32 -0500
Date: Thu, 13 Nov 2014 10:41:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Aaron Lu <aaron.lu@intel.com>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH 0/3] Support PMIC operation region for CrystalCove and
 XPower
Message-ID: <20141113104126.GM24004@x1>
References: <1414735705-18366-1-git-send-email-aaron.lu@intel.com>
 <3052882.EdcZmghHR3@vostro.rjw.lan>
 <20141112094419.GC24004@x1>
 <1668657.Fqph6NyFNz@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1668657.Fqph6NyFNz@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Rafael J. Wysocki wrote:

> On Wednesday, November 12, 2014 09:44:19 AM Lee Jones wrote:
> > On Wed, 12 Nov 2014, Rafael J. Wysocki wrote:
> > 
> > > On Tuesday, November 11, 2014 11:11:52 AM Lee Jones wrote:
> > > > On Tue, 11 Nov 2014, Aaron Lu wrote:
> > > > 
> > > > > On 10/31/2014 02:08 PM, Aaron Lu wrote:
> > > > > > On Intel Baytrail-T and Baytrail-T-CR platforms, there are two customized
> > > > > > ACPI operation regions defined for the Power Management Integrated Circuit
> > > > > > device, one is for power resource handling and one is for thermal: sensor
> > > > > > temperature reporting, trip point setting, etc. There are different PMIC
> > > > > > chips used on those platforms and though each has the same two operation
> > > > > > regions and functionality, their implementation is different so every PMIC
> > > > > > will need a driver. But since their functionality is similar, some common
> > > > > > code is abstracted into the intel_soc_pmic_opregion.c.
> > > > > > 
> > > > > > The last version is posted here:
> > > > > > https://lkml.org/lkml/2014/9/8/801
> > > > > > 
> > > > > > Changes since then:
> > > > > > 1 Move to drivers/acpi as discussed on the above thread;
> > > > > > 2 Added support for XPower AXP288 PMIC operation region support;
> > > > > > 3 Since operation region handler can not be removed(at the moment at least),
> > > > > >   use bool for the two operation region driver configs instead of tristate;
> > > > > >   Another reason to do this is that, with Mika's MFD ACPI support patch, all
> > > > > >   those MFD cell devices created will have the same modalias as their parent's
> > > > > >   so it doesn't make much sense to compile these drivers into modules.
> > > > > > 
> > > > > > Patch 1 applies on top of Rafael's pm-next branch, and then patch 2 and
> > > > > > patch 3 needs merge of Lee's mfd/ib-mfd-iio-3.19 branch where the PMIC
> > > > > > driver XPower AXP288 and iio driver axp288_adc is located.
> > > > > 
> > > > > Since patch 2-3 are based on top of the mfd/ib-mfd-iio-3.19 branch, it
> > > > > would be easy to go through the mfd/ib-mfd-iio-3.19 branch.
> > > > > 
> > > > > Rafael,
> > > > > Can I get your ACK for the three patches?
> > > > > 
> > > > > Lee,
> > > > > Can you please take the series if Rafael gives it ack?
> > > > 
> > > > Yes, no problem.
> > > 
> > > Well, since the code is going to reside mostly in drivers/acpi, I think I should
> > > be applying the patches and from your response it looks like you are fine with
> > > them.  Is that correct?
> > 
> > I read that this set has dependencies on patches which are already in
> > the MFD tree.  If that's not the case please go ahead and apply them
> > with my Ack for the MFD components.
> 
> I thought you had a branch that I could pull into my tree and apply the patches
> on top of it.  At least that was my understanding of the Aaron's message, so
> please let me know if that's not the case.

That is absolutely the case.  'mfd/ib-mfd-iio-3.19' is good to go.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
