Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbaHEJbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:31:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:31845 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbaHEJbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:31:11 -0400
X-IronPort-AV: E=Sophos;i="5.01,804,1400025600"; 
   d="scan'208";a="159434959"
Message-ID: <53E0A45C.4050400@citrix.com>
Date: Tue, 5 Aug 2014 10:31:08 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <gregkh@linuxfoundation.org>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v5] Fixes to Xen pciback for 3.17.
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>	<53DBB27D.2040203@citrix.com>	<20140804184318.GB9009@laptop.dumpdata.com> <75613802.20140805104438@eikelenboom.it>
In-Reply-To: <75613802.20140805104438@eikelenboom.it>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/14 09:44, Sander Eikelenboom wrote:
> 
> Monday, August 4, 2014, 8:43:18 PM, you wrote:
> 
>> On Fri, Aug 01, 2014 at 04:30:05PM +0100, David Vrabel wrote:
>>> On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
>>>> Greg: goto GHK
>>>>
>>>> This is v5 version of patches to fix some issues in Xen PCIback.
>>>
>>> Applied to devel/for-linus-3.17.
> 
>> Thank you.
>>>
>>> I dropped the stable Cc for #2 pending a final decision on whether it
>>> really is a stable candidate.
> 
>> OK.
>>>
>>> David
> 
> Hi Konrad / David,
> 
> This series still lacks a resolution on the sysfs /do_flr /reset,
> as a result the pci devices are not reset after shutdown of a guest.
> (no more pciback 0000:xx:xx.x: restoring config space at offset xxx)
> 
> So this series now introduces a regression to 3.16, which causes devices to malfunction 
> after a guest reboot or after assigning the devices to another guest.

I don't follow what you're saying.  The lack of a device reset for PCI
devices with no FLR method isn't a regression as this has never worked.
 Can you explain in more detail what the regression is and which patch
caused it?

> Apart from that .. i can't resist to remind the other issue with removing pci
> devices passed through to HVM guests related to the signaling via xenstore,
> described in:
> 
> http://lists.xen.org/archives/html/xen-devel/2014-07/msg01875.html

I don't remember seeing you posting a patch...?

David
