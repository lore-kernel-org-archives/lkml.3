Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbaGNRnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:43:17 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:49735 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbaGNRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:43:09 -0400
Date: Mon, 14 Jul 2014 19:43:04 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <9210423415.20140714194304@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: konrad@kernel.org, xen-devel@lists.xenproject.org,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v4] PCI back fixes for 3.17.
In-Reply-To: <20140714173753.GB12920@laptop.dumpdata.com>
References: <1405109332-31659-1-git-send-email-konrad@kernel.org> <768165707.20140714183755@eikelenboom.it> <20140714172225.GA10497@laptop.dumpdata.com> <652296445.20140714192923@eikelenboom.it> <20140714173753.GB12920@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Monday, July 14, 2014, 7:37:53 PM, you wrote:

>> >> Ad B)
>> >> 
>> >> root@dom0:~# xl pci-list router
>> >> Vdev Device
>> >> 05.0 0000:00:1b.0
>> >> 
>> >> root@dom0:~# xl pci-assignable-list
>> >> 0000:02:00.0
>> >> 
>> >> root@dom0:~# xl pci-detach router 00:1b.0
>> >> dmesg shows:
>> >> [  199.742668] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
>> >> [  199.743527] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
>> >> [  199.744321] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> >> [  199.757184] xen-pciback pci-1-0: xen_pcibk_xenbus_remove freeing pdev @ 0xffff8800589fce40
>> >> [  199.758139] xen-pciback pci-1-0: xen_pcibk_disconnect pdev @ 0xffff8800589fce40
>> >> [  199.862595] xen: xen_unregister_device_domain_owner
>> >> 
>> >> xl dmesg shows:
>> >> (XEN) [2014-07-14 16:28:29] memory_map:remove: dom1 gfn=f3070 mfn=f7d30 nr=4
>> >> (XEN) [2014-07-14 16:28:29] io.c:322: d1: unbind: m_gsi=22 g_gsi=36 dev=00:00.5 intx=0
>> >> (XEN) [2014-07-14 16:28:29] io.c:390: d1 unmap: m_irq=22 dev=00:00.5 intx=0
>> >> (XEN) [2014-07-14 16:28:29] [VT-D]iommu.c:1579: d1:PCIe: unmap 0000:00:1b.0
>> >> (XEN) [2014-07-14 16:28:29] [VT-D]iommu.c:1440: d0:PCIe: map 0000:00:1b.0
>> >> 
>> >> root@dom0:~# xl pci-list router
>> >> root@dom0:~# xl pci-assignable-list
>> >> 0000:00:1b.0
>> >> 0000:02:00.0
>> >> 
>> >> root@dom0:~# xl pci-assignable-remove 00:1b.0
>> >> dmesg shows:
>> >> [  318.827415] xen: xen_unregister_device_domain_owner
>> >> [  318.828771] xen: xen_unregister_device_domain_owner: ENODEV
>> >> [  318.930869] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
>> >> [  318.933435] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
>> >> [  318.935877] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> >> 
>> >> root@dom0:~# xl pci-list router
>> >> root@dom0:~# xl pci-assignable-list
>> >> 0000:02:00.0
>> >> 
>> >> 
>> 
>> > And if you do:
>> 
>> > # xl pci-detach router 02:00.0
>> 

> Err, I meant
> # xl pci-assignable-remove 02:00.0

Ah ok .. so that is:
remove a device from pciback that has never been assigned to any guest .. 

will also give that a go .. although that probably won't be a problem. 

>> > Do you see it being cleared from pciback? And what do you
>> > see in /sys/bus/pci/drivers/pciback ?
>> 
>> Hmm good point .. i also had the plan to look into xenstore what was in there .. 
>> but forgot .. will post both right away :-) 

> Thank you!
>> 
>> > Thanks!
>> 
>> 


