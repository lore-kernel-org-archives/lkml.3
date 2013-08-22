Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3HUXvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:51:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54107 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab3HUXvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:51:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Darren Hart <dvhart@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI vs Device Tree - moving forward
Date: Thu, 22 Aug 2013 02:02:29 +0200
Message-ID: <1810269.JOHnJ0H7P9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130821233942.GA21502@srcf.ucam.org>
References: <20130820192650.GA19470@srcf.ucam.org> <6438184.2yT2NMB1CE@vostro.rjw.lan> <20130821233942.GA21502@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 22, 2013 12:39:42 AM Matthew Garrett wrote:
> On Thu, Aug 22, 2013 at 01:11:14AM +0200, Rafael J. Wysocki wrote:
> 
> > Moreover, even if we are able to instruct everyone interested how to create
> > the requisite ACPI tables, there is the little problem of shipping them
> > somehow so that they actually can be used by the kernel that needs to be
> > addressed too.
> 
> I think the expectation in the ACPI ecosystem has to be that devices 
> ship their own ACPI tables. I can't see any benefit in using ACPI if the 
> aim is to just carry on shipping files with the kernel or install media 
> - in that case, just use DT.

And now the practice appears to be that vendors actually ship some ACPI
tables with their systems, but those ACPI tables do not contain information
needed to enumerate all devices.  On the other hand, it is known what the
DT bindings for the missing part should be.  How can we address this?

Next, say we have a driver written with DT bindings in mind and there's
an ACPI-based system with identical hardware, although wired up slightly
differently.  Say that all of the information needed by that driver is
there in the ACPI tables (Q: How the vendor is supposed to know what
information the driver expects?).  Who is supposed to take care of updating
the driver to be able to use ACPI in addition to DTs?

I don't honestly think that the "ask vendors to ship their systems with correct
ACPI tables" approach will take us anywhere.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
