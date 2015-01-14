Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbbANO6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:58:39 -0500
Received: from smtp.citrix.com ([66.165.176.89]:8739 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbbANO6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:58:38 -0500
X-IronPort-AV: E=Sophos;i="5.07,756,1413244800"; 
   d="scan'208";a="215970190"
Message-ID: <54B68419.9010503@citrix.com>
Date: Wed, 14 Jan 2015 14:58:33 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.19-rc4: Xen pci-passthrough regression, bisected to commit
 cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687 "x86, irq: Keep balance of IOAPIC
 pin reference count"
References: <74756708.20150114151521@eikelenboom.it>
In-Reply-To: <74756708.20150114151521@eikelenboom.it>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/15 14:15, Sander Eikelenboom wrote:
> Hi Gerry / David / Konrad,
> 
> Some more testing uncovered another issue under Xen, this time with PCI-passthrough.

What device?  In particular what interrupts is it using?

> I have bisected it to the following commit: 
> cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687 "x86, irq: Keep balance of IOAPIC pin reference count"
> 
> It causes these symptoms:
> 
> - On Intel
>   - Running on Xen with pci devices seized on host boot with xen-pciback.hide= parameter
>   - Running a HVM guest with PCI passthrough of two devices (NIC + wireless NIC)
>   - While the driver loads fine, the device isn't working properly, looking in /proc/interrupts in the guest
>     shows that it doesn't receive any interrupts.
>   - Reverting this particular commit (in the dom0 kernel only) makes the device receive interrupts and work properly again.
> 
> - On AMD (more subtle symptom) 
>   - Running on Xen with pci devices seized on host boot with xen-pciback.hide= parameter
>   - Running a HVM guest with PCI passthrough of one devices (videograbber)
>   - While the driver loads fine and the device looks like it's working, the videostream isn't stable and it skips or repeats frames.
>   - Reverting this particular commit (in the dom0 kernel only) makes the device work properly again with a stable videostream.
> 
> --
> Sander
> 

