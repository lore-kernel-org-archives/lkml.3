Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbaGNUdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:33:42 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57673 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbaGNUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:33:40 -0400
Date: Mon, 14 Jul 2014 13:33:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@alien8.de>, jdelvare@suse.de,
        rdunlap@infradead.org, bhelgaas@google.com, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] hwmon, k10temp: Add support for AMD F15h M60h processor
Message-ID: <20140714203336.GA30926@roeck-us.net>
References: <1405369388-12729-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140714195128.GA25124@pd.tnic>
 <53C43BDF.2070403@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C43BDF.2070403@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:21:51PM +0200, Clemens Ladisch wrote:
> Borislav Petkov wrote:
> > On Mon, Jul 14, 2014 at 03:23:08PM -0500, Aravind Gopalakrishnan wrote:
> >> +	if (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model == 0x60) {
> >> +		pci_bus_write_config_dword(pdev->bus, PCI_DEVFN(0, 0),
> >> +					   NB_SMU_IND_ADDR, IND_ADDR_OFFSET);
> >> +		pci_bus_read_config_dword(pdev->bus, PCI_DEVFN(0, 0),
> >> +					  NB_SMU_IND_DATA, &regval);
> 
> How do you prevent races with any other code that accesses some indirect
> register?
> 
I just wanted to ask exactly the same question. I think this will need
locking.

> >> +
> >> +	} else
> >> +		pci_read_config_dword(pdev, REG_REPORTED_TEMPERATURE, &regval);
> 
> Why the empty line?  Also, use braces in both branches.
> 
Agreed. Too bad the respective checkpatch warning was moved to --strict.

Guenter
