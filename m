Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaBTRpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:45:13 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:58889 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbaBTRpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:45:10 -0500
Date: Thu, 20 Feb 2014 10:45:03 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pcie: Add Xilinx PCIe Host Bridge IP driver
Message-ID: <20140220174503.GB19893@obsidianresearch.com>
References: <1392564830-5868-1-git-send-email-sthokal@xilinx.com>
 <CAErSpo5FGPhgnp8Gfy-1_Lk7ckCi7U5+z5pLnPU+jScPxD5yUQ@mail.gmail.com>
 <20140219003523.GJ29304@obsidianresearch.com>
 <CA+mB=1KSxkN+mKce5k1n93pmAA_FnWYaqNweWzxd4GD3Mo4PZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+mB=1KSxkN+mKce5k1n93pmAA_FnWYaqNweWzxd4GD3Mo4PZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 12:39:48PM +0530, Srikanth Thokala wrote:

> > These should use the standard ranges mechanism for translations and
> > apertures.
> 
> This AXI PCIe bridge IP do have two kind of BARs AXI-to-PCIe BAR and
> PCIe-to-AXI BAR.  The former specifies the AXI Base address and are the
> memory windows, these are listed in the 'ranges' DT property.  The latter
> BAR specifies the addresses that PCI Express should respond to/is

The PCIe-to-AXI window should be setup by the driver automatically to
span all system memory, it doesn't need to be in DT.

The AXI-to-PCIe is the host bridge aperture and it should be in the DT
ranges.

> tallowed to write to and these addresses written to configuration space
> during the initialization.

Hopefully this was done in a conformant way, please provide a lspci
-vv next round please..

> > Also, IMHO, only root ports should be supported in a host bridge
> > driver. A PCI end point is something entirely different.
> 
> We are not supporting end point in this driver.  This is a soft IP
> and can be configurable as a Root Port/End point while creating a HW
> design in the FPGA.  So, the driver use this DT property to first
> check if it is configured for Root Port and bail out if it is not.

This is something that should be handled via the compatible string, not
special properties. Root port and End port will have different
drivers, so they must have different compatible strings.

There is nothing wrong with dumping core generator configuration
properties into the DT (as a form of documentation), but you must
still use the standard techniques and properties whenever possible.

Jason
