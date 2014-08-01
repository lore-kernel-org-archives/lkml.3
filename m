Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaHAO7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:59:46 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60844 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaHAO7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:59:45 -0400
X-IronPort-AV: E=Sophos;i="5.01,780,1400025600"; 
   d="scan'208";a="158490858"
Message-ID: <53DBAB5E.70707@citrix.com>
Date: Fri, 1 Aug 2014 15:59:42 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v5 1/6] xen-pciback: Document the various
 parameters and attributes in SysFS
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>	<1405354736-7358-2-git-send-email-konrad.wilk@oracle.com>	<53D64A52.7030705@citrix.com> <20140728145636.GC8027@kroah.com>
In-Reply-To: <20140728145636.GC8027@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/14 15:56, Greg KH wrote:
> On Mon, Jul 28, 2014 at 02:04:18PM +0100, David Vrabel wrote:
>> On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
>>> Which hadn't been done with the initial commit.
>>>
>>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>> ---
>>> v2: Dropped the parameters and one that is unlikeable.
>>> ---
>>>  Documentation/ABI/testing/sysfs-driver-pciback | 25 +++++++++++++++++++++++++
>>>  1 file changed, 25 insertions(+)
>>>  create mode 100644 Documentation/ABI/testing/sysfs-driver-pciback
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-driver-pciback b/Documentation/ABI/testing/sysfs-driver-pciback
>>> new file mode 100644
>>> index 0000000..cdc8340
>>> --- /dev/null
>>> +++ b/Documentation/ABI/testing/sysfs-driver-pciback
>>> @@ -0,0 +1,25 @@
>>> +What:           /sys/bus/pci/drivers/pciback/quirks
>>> +Date:           Oct 2011
>>> +KernelVersion:  3.1
>>> +Contact:        xen-devel@lists.xenproject.org
>>> +Description:
>>> +                If the permissive attribute is set, then writing a string in
>>> +                the format of DDDD:BB:DD.F-REG:SIZE:MASK will allow the guest
>>> +                to write and read from the PCI device. That is Domain:Bus:
>>
>> "...write and read the PCI device's configuration space."
> 
> How is this different from the normal pci device config file?

This is setting the permissions for a guest to access the real hardware
PCI config space (instead of the virtualized config space which the
guest has access to by default).

The guest access the config space using the normal methods (the file or
the kernel functions).

David
