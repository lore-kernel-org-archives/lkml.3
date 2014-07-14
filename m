Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbaGNQ3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:29:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40332 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbaGNQ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:28:54 -0400
Date: Mon, 14 Jul 2014 12:28:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/5] xen-pciback: Document the various parameters and
 attributes in SysFS
Message-ID: <20140714162839.GA7609@laptop.dumpdata.com>
References: <1405109332-31659-1-git-send-email-konrad@kernel.org>
 <1405109332-31659-2-git-send-email-konrad@kernel.org>
 <53C04D27.3050807@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C04D27.3050807@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 04:46:31PM -0400, Boris Ostrovsky wrote:
> On 07/11/2014 04:08 PM, konrad@kernel.org wrote:
> >From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >
> >Which hadn't been done with the initial commit.
> >
> >Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >---
> >v2: Dropped the parameters and one that is unlikeable.
> >---
> >  Documentation/ABI/testing/sysfs-driver-pciback |   25 ++++++++++++++++++++++++
> >  1 files changed, 25 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-driver-pciback
> >
> >diff --git a/Documentation/ABI/testing/sysfs-driver-pciback b/Documentation/ABI/testing/sysfs-driver-pciback
> >new file mode 100644
> >index 0000000..e482240
> >--- /dev/null
> >+++ b/Documentation/ABI/testing/sysfs-driver-pciback
> >@@ -0,0 +1,25 @@
> >+What:           /sys/bus/pci/drivers/pciback/quirks
> >+Date:           Oct 2011
> >+KernelVersion:  3.1
> >+Contact:        xen-devel@lists.xenproject.org
> >+Description:
> >+                If the permissive attribute is set, then writing a string in
> >+                the format of DDDD:BB:DD.F-REG:SIZE:MASK will allow the guest
> >+                to write and read from the PCI device. That is Domain:Bus:
> >+                Device.Function-Register:Size:Mask (Domain is optional).
> >+                For example:
> >+                #echo 00:19.0-E0:2:FF > /sys/bus/pci/drivers/pciback/quirks
> >+                will allow the guest to read and write to the configuration
> >+                register 0x0E.
> >+
> >+What:           /sys/bus/pci/drivers/pciback/irq_handlers
> >+Date:           Oct 2011
> >+KernelVersion:  3.1
> >+Contact:        xen-devel@lists.xenproject.org
> >+Description:
> >+                A list of all of the PCI devices owned by Xen PCI back and
> >+                whether Xen PCI backend will acknowledge the interrupts received
> >+                and the amount of interrupts received. Xen PCI back acknowledges
> >+                said interrupts only when they are level, shared with another
> >+                guest, and enabled by the guest.
> 
> There are 4 fields per device. This description misses isr_on.

Grrr. I missed this in my repost. Will fix it to say on the last line:
'guest, whether it will acknowledge interrupts, and enabled by the guest'.

> 
> -boris
> 
