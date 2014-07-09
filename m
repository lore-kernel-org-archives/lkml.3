Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaGIMRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:17:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:11335 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaGIMRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:17:08 -0400
X-IronPort-AV: E=Sophos;i="5.01,631,1400025600"; 
   d="scan'208";a="151205435"
Message-ID: <53BD32C2.6000306@citrix.com>
Date: Wed, 9 Jul 2014 13:17:06 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <konrad@kernel.org>, <xen-devel@lists.xenproject.org>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v3 1/7] xen-pciback: Document the various
 parameters and attributes in SysFS
References: <1404845909-13563-1-git-send-email-konrad@kernel.org> <1404845909-13563-2-git-send-email-konrad@kernel.org>
In-Reply-To: <1404845909-13563-2-git-send-email-konrad@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 19:58, konrad@kernel.org wrote:
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Which hadn't been done with the initial commit.
[...]
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-pciback
> @@ -0,0 +1,84 @@
> +What:           /sys//module/xen_pciback/parameters/verbose_request

It's my understanding that module parameters are not typically part of
the ABI.

> +What:           /sys/module/xen_pciback/parameters/permissive
> +Date:           Oct 2011
> +KernelVersion:  3.1
> +Contact:        xen-devel@lists.xenproject.org
> +Description:
> +                Allow non-emulated (raw) access to PCI configuration space by
> +                the guest frontend. This can have adverse affect as the guest
> +                can destabilize the initial domain.

WTF?  Why does it even have such an unsafe option?


> +What:           /sys/bus/pci/drivers/pciback/irq_handlers
> +Date:           Oct 2011
> +KernelVersion:  3.1
> +Contact:        xen-devel@lists.xenproject.org
> +Description:
> +                A list of all of the PCI devices owned by Xen PCI back and
> +                whether Xen PCI backend will acknowledge the interrupts received
> +                and the amount of interrupts received. Xen PCI back acknowledges
> +                said interrupts only when they are level, shared with another
> +                guest, and enabled by the guest.

This should be a device property or something in debugfs.

> +What:           /sys/bus/pci/drivers/pciback/irq_handler_state
> +Date:           Oct 2011
> +KernelVersion:  3.1
> +Contact:        xen-devel@lists.xenproject.org
> +Description:
> +                An option to toggle Xen PCI back to acknowledge (or stop)
> +                interrupts for the specific device regardless of whether the
> +                device is shared, enabled, or on a level interrupt line.
> +                Writing a string of DDDD:BB:DD.F will toggle the state.
> +                This is Domain:Bus:Device.Function where domain is optional.

I do not understand under what circumstances this should be used in.

David

