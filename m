Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbaGHWcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:32:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaGHWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:32:50 -0400
Date: Tue, 8 Jul 2014 15:37:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: a.motakis@virtualopensystems.com, alex.williamson@redhat.com,
        kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, jhovold@gmail.com, will.deacon@arm.com,
        a.rigo@virtualopensystems.com, rob.herring@calxeda.com,
        stuart.yoder@freescale.com, rob@landley.net, grant.likely@linaro.org,
        tech@virtualopensystems.com, clbchenlibo.chen@huawei.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        Julien Grall <julien.grall@linaro.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] driver core: platform: add device binding path
 'driver_override'
Message-ID: <20140708223714.GA15197@kroah.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
 <1398700371-20096-2-git-send-email-a.motakis@virtualopensystems.com>
 <20140602194258.5135925bf3c71b9c010fb409@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602194258.5135925bf3c71b9c010fb409@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 07:42:58PM -0500, Kim Phillips wrote:
> Needed by platform device drivers, such as the upcoming
> vfio-platform driver, in order to bypass the existing OF, ACPI,
> id_table and name string matches, and successfully be able to be
> bound to any device, like so:
> 
> echo vfio-platform > /sys/bus/platform/devices/fff51000.ethernet/driver_override
> echo fff51000.ethernet > /sys/bus/platform/devices/fff51000.ethernet/driver/unbind
> echo fff51000.ethernet > /sys/bus/platform/drivers_probe
> 
> This mimics "PCI: Introduce new device binding path using
> pci_dev.driver_override", which is an interface enhancement
> for more deterministic PCI device binding, e.g., when in the
> presence of hotplug.
> 
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> Reviewed-by: Alexander Graf <agraf@suse.de>
> Reviewed-by: Stuart Yoder <stuart.yoder@freescale.com>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> ---
> Greg,
> 
> This is largely identical to the PCI version of the same that has
> been accepted for v3.16 and ack'd by you:
> 
> https://lists.cs.columbia.edu/pipermail/kvmarm/2014-May/009674.html
> 
> and applied to Bjorn Helgaas' PCI tree:
> 
> https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/virtualization&id=782a985d7af26db39e86070d28f987cad21313c0
> 
> You are the platform driver core maintainer: can you apply this to
> your driver-core tree now?

Sorry for the very long delay, it's now merged in my tree.

Thanks for being persistant.

greg k-h
