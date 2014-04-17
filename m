Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaDQLRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:17:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47976 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaDQLRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:17:10 -0400
Date: Thu, 17 Apr 2014 12:16:43 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pwm_lpss: Add support for PCI devices
Message-ID: <20140417121643.2c07ecfc@alan.etchedpixels.co.uk>
In-Reply-To: <20140417110756.GB32603@ulmo>
References: <1397672338-3510-1-git-send-email-chiau.ee.chew@intel.com>
	<20140417110756.GB32603@ulmo>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static int pci_drv, plat_drv;	/* So we know which drivers registered */
> 
> I think that rather than having everything in a single file, perhaps a
> better approach would be to keep pwm-lpss.c as a common module and then
> have separate drivers for ACPI (pwm-lpss-acpi) and PCI (pwm-lpss-pci).
> That way you don't have to keep track of which driver was successfully
> registered.

It would then take up 16K for a tiny trivial piece of code

> Would that work?

Badly

> > +static const struct pwm_lpss_boardinfo byt_info = {
> 
> What does byt_ stand for?

Baytrail.

> > -static int pwm_lpss_probe(struct platform_device *pdev)
> > +static struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,
> > +			struct resource *r, struct pwm_lpss_boardinfo *info)
> 
> Indentation is odd here. Please align arguments one subsequent lines
> with those of the first.

That doesn't appear to be present in CodingStyle or indeed most of the
kernel.

> > -static struct platform_driver pwm_lpss_driver = {
> > +static int pwm_lpss_probe_pci(struct pci_dev *pdev,
> > +			      const struct pci_device_id *id)
> > +{
> > +	struct pwm_lpss_boardinfo *info;
> 
> I think this should be const to mirror the type of the byt_info
> variable.

Agreed

Alan
