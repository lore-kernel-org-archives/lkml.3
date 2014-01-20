Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaATOge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:36:34 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62287 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaATOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:36:31 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC part2 PATCH 8/9] ACPI / ARM64: Update acpi_register_gsi to register with the core IRQ subsystem
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linaro-acpi@lists.linaro.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-acpi@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Olof Johansson <olof@lixom.net>, Bjorn Helgaas <bhelgaas@google.com>
In-Reply-To: <201312110623.04341.arnd@arndb.de>
References: <1385999094-3152-1-git-send-email-hanjun.guo@linaro.org> < 1385999094-3152-9-git-send-email-hanjun.guo@linaro.org> <20131210130521. 3FE89C40A27@trevor.secretlab.ca> <201312110623.04341.arnd@arndb.de>
Date: Mon, 20 Jan 2014 14:36:25 +0000
Message-Id: <20140120143625.EB0E2C40B12@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 06:23:04 +0100, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 10 December 2013, Grant Likely wrote:
> > > --- a/drivers/acpi/plat/arm-core.c
> > > +++ b/drivers/acpi/plat/arm-core.c
> > > @@ -90,7 +90,7 @@ enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_GIC;
> > >  
> > >  static unsigned int gsi_to_irq(unsigned int gsi)
> > >  {
> > > -     int irq = irq_create_mapping(NULL, gsi);
> > > +     int irq = irq_find_mapping(NULL, gsi);
> > 
> > I suspect this will break FDT users that depend on the old behaviour.
> 
> I think not, given this is only in drivers/acpi and gets added in one
> of the prior patches of the same series.

Ah, okay.

g.

