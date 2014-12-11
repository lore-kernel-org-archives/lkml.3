Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbaLKSLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:11:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaLKSLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:11:38 -0500
Date: Thu, 11 Dec 2014 13:11:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dely Sy <dely.l.sy@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Special handling of display/VGA devices in hotplug drivers
Message-ID: <20141211181136.GA11367@kroah.com>
References: <CAErSpo4iZCUZgqNi-fX+YX=sKV=Ae5z8kn8-++E0Cgft9unmBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4iZCUZgqNi-fX+YX=sKV=Ae5z8kn8-++E0Cgft9unmBg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 10:34:30AM -0700, Bjorn Helgaas wrote:
> It looks like you added the initial pciehp driver [1], which includes
> the following code in pciehp_disable_slot():
> 
> + if (class_code == PCI_BASE_CLASS_DISPLAY) {
> + /* Display/Video adapter (not supported) */
> + rc = REMOVE_NOT_SUPPORTED;
> 
> + /* If it's a bridge, check the VGA Enable bit */
> + if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
> + rc = pci_bus_read_config_byte (pci_bus, devfn, PCI_BRIDGE_CONTROL, &BCR);
> + if (rc)
> + return rc;
> +
> + /* If the VGA Enable bit is set, remove isn't supported */
> + if (BCR & PCI_BRIDGE_CTL_VGA) {
> + rc = REMOVE_NOT_SUPPORTED;
> 
> I'm trying to figure out why VGA devices are handled specially.  I
> can't find anything in the PCI specs that mentions this.  Most of the
> other PCI hotplug drivers have similar code.  Do you remember anything
> about this?

The PCI spec said that you were not allowed to hotplug VGA drivers.  The
big issue is that POST usually needs to run on those things, and there
is no way to POST a PCI hotplugged device.

Does the spec not say that anymore?  I haven't looked in years at it...

Do you want to hot-add a VGA device?  Are these lines causing a problem
with something?

thanks,

greg k-h
