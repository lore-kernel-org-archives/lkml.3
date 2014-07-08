Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaGHSDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:03:15 -0400
Received: from smtp.citrix.com ([66.165.176.89]:18472 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbaGHSDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:03:11 -0400
X-IronPort-AV: E=Sophos;i="5.01,626,1400025600"; 
   d="scan'208";a="150676002"
Message-ID: <53BC324B.5090600@citrix.com>
Date: Tue, 8 Jul 2014 19:02:51 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <konrad@kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3 4/7] xen/pciback: Implement PCI reset slot or bus with
 'do_flr' SysFS attribute
References: <1404845909-13563-1-git-send-email-konrad@kernel.org> <1404845909-13563-5-git-send-email-konrad@kernel.org>
In-Reply-To: <1404845909-13563-5-git-send-email-konrad@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 19:58, konrad@kernel.org wrote:
> --- a/Documentation/ABI/testing/sysfs-driver-pciback
> +++ b/Documentation/ABI/testing/sysfs-driver-pciback
> @@ -82,3 +82,14 @@ Description:
>                  device is shared, enabled, or on a level interrupt line.
>                  Writing a string of DDDD:BB:DD.F will toggle the state.
>                  This is Domain:Bus:Device.Function where domain is optional.
> +
> +What:           /sys/bus/pci/drivers/pciback/do_flr
> +Date:           July 2014
> +KernelVersion:  3.16
> +Contact:        xen-devel@lists.xenproject.org
> +Description:
> +                An option to slot or bus reset an PCI device owned by
> +                Xen PCI backend. Writing a string of DDDD:BB:DD.F will cause
> +                the driver to perform an slot or bus reset if the device
> +                supports. It also checks to make sure that all of the devices
> +                under the bridge are owned by Xen PCI backend.

Not sure I like this new interface.  I solved this by adding a new reset
file that looked like the regular one the pci would have if it supported
FLR.  I'm fairly sure I posted a series for this.  Was there a reason
you didn't do this?

David
