Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3HVADK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:03:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60464 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3HVADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:03:08 -0400
Date: Thu, 22 Aug 2013 01:03:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Darren Hart <dvhart@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI vs Device Tree - moving forward
Message-ID: <20130822000306.GA21785@srcf.ucam.org>
References: <20130820192650.GA19470@srcf.ucam.org>
 <6438184.2yT2NMB1CE@vostro.rjw.lan>
 <20130821233942.GA21502@srcf.ucam.org>
 <1810269.JOHnJ0H7P9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1810269.JOHnJ0H7P9@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 02:02:29AM +0200, Rafael J. Wysocki wrote:

> And now the practice appears to be that vendors actually ship some ACPI
> tables with their systems, but those ACPI tables do not contain information
> needed to enumerate all devices.  On the other hand, it is known what the
> DT bindings for the missing part should be.  How can we address this?

On ARM? I know that this is true on x86, but that's because x86 vendors 
have never intended i2c hardware monitoring devices be driven by a 
general purpoes OS - they're there for the benefit of the firmware, not 
anything above that.

> Next, say we have a driver written with DT bindings in mind and there's
> an ACPI-based system with identical hardware, although wired up slightly
> differently.  Say that all of the information needed by that driver is
> there in the ACPI tables (Q: How the vendor is supposed to know what
> information the driver expects?).  Who is supposed to take care of updating
> the driver to be able to use ACPI in addition to DTs?

Ideally we have a consistent in-kernel representation of this 
information and drivers don't need to care about whether it came from DT 
or ACPI, but like I said, that's going to be tricky.

> I don't honestly think that the "ask vendors to ship their systems with correct
> ACPI tables" approach will take us anywhere.

It's worked well enough on x86. If hardware vendors don't actually test 
that their hardware is able to boot the OS it's intended to run then 
there's very little we can do about that - and the worst case outcome is 
that people just ignore the shipped ACPI and use FDT.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
