Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaDHCtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 22:49:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60257 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaDHCs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 22:48:58 -0400
Date: Tue, 8 Apr 2014 03:48:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Peter Tyser <ptyser@xes-inc.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Adding interrupt support to gpio-ich driver (possibly via SCI)
Message-ID: <20140408024851.GA3594@srcf.ucam.org>
References: <533EDD0E.8010304@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533EDD0E.8010304@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 09:25:50AM -0700, Guenter Roeck wrote:

> Is there a clean way to use any of those to implement interrupt support
> for this driver ? I thought about hijacking the SCI interrupt by registering
> an interrupt handler with acpi_install_sci_handler(), but that would restrict
> the driver to kernel only (or the acpi function would have to be exported),
> and I have no idea if it would work or, more importantly, if it would be
> the best approach to solve the problem, or if the result would be acceptable.
> I can figure out the "working" part, but that would not help much if I would
> have to carry the patch locally because it is not acceptable for upstream
> integration.

You shouldn't need to install an SCI handler - the way the hardware will 
generate an SCI is to raise a GPE. If you know which GPE the device 
raises (my recollection is that for most Intel chipsets it's GPIO number 
+ 0x10) then you can just call acpi_install_gpe_handler(). The problem 
is that the firmware may well already be using some of those GPIOs, and 
there's no easy way to tell. Checking the interrupt configuration isn't 
sufficient, since some of them may just be used as outputs.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
