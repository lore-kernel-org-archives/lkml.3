Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaGKUoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:44:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39256 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaGKUoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:44:22 -0400
Message-ID: <53C04D27.3050807@oracle.com>
Date: Fri, 11 Jul 2014 16:46:31 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: konrad@kernel.org, xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 1/5] xen-pciback: Document the various parameters and
 attributes in SysFS
References: <1405109332-31659-1-git-send-email-konrad@kernel.org> <1405109332-31659-2-git-send-email-konrad@kernel.org>
In-Reply-To: <1405109332-31659-2-git-send-email-konrad@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 04:08 PM, konrad@kernel.org wrote:
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
> Which hadn't been done with the initial commit.
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> v2: Dropped the parameters and one that is unlikeable.
> ---
>   Documentation/ABI/testing/sysfs-driver-pciback |   25 ++++++++++++++++++++++++
>   1 files changed, 25 insertions(+), 0 deletions(-)
>   create mode 100644 Documentation/ABI/testing/sysfs-driver-pciback
>
> diff --git a/Documentation/ABI/testing/sysfs-driver-pciback b/Documentation/ABI/testing/sysfs-driver-pciback
> new file mode 100644
> index 0000000..e482240
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-pciback
> @@ -0,0 +1,25 @@
> +What:           /sys/bus/pci/drivers/pciback/quirks
> +Date:           Oct 2011
> +KernelVersion:  3.1
> +Contact:        xen-devel@lists.xenproject.org
> +Description:
> +                If the permissive attribute is set, then writing a string in
> +                the format of DDDD:BB:DD.F-REG:SIZE:MASK will allow the guest
> +                to write and read from the PCI device. That is Domain:Bus:
> +                Device.Function-Register:Size:Mask (Domain is optional).
> +                For example:
> +                #echo 00:19.0-E0:2:FF > /sys/bus/pci/drivers/pciback/quirks
> +                will allow the guest to read and write to the configuration
> +                register 0x0E.
> +
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

There are 4 fields per device. This description misses isr_on.

-boris

