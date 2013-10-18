Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3JRFd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 01:33:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51568 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3JRFdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 01:33:25 -0400
X-AuditID: cbfee691-b7fe06d0000008c4-b7-5260c7df26dd
From: Jingoo Han <jg1.han@samsung.com>
To: zhenzhong.duan@oracle.com, "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'xen-devel'" <xen-devel@lists.xen.org>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Feng Jin'" <joe.jin@oracle.com>,
        "'Sucheta Chakraborty'" <sucheta.chakraborty@qlogic.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <525E3320.5080700@oracle.com>
In-reply-to: <525E3320.5080700@oracle.com>
Subject: Re: [PATCH 2/3] PCI: Refactor MSI/MSIX mask restore code to fix
 interrupt lost issue
Date: Fri, 18 Oct 2013 14:32:14 +0900
Message-id: <000101cecbc3$67291550$357b3ff0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7KOYaStloiOkVxSduFPcm2xLa+xQBib7Zg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zY937xxOCDE68lLBY0pRhcXnhJVaL
	R33PGS2WLX7KaHF51xw2i7PzjrNZXPp0jtFiycfFLBabfz5mceD0WLCp1OPo7t9MHh+f3mLx
	WPflBLtH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZXx9uIS5YJtMRde8l0wNjGtEuhg5OSQE
	TCQOfDjNDmGLSVy4t56ti5GLQ0hgGaPEgtlzGWGKTrw9D5VYxCix+dYaZgjnF6PEm1VdLCBV
	bAJqEl++HAYbJSLgIrF+J0ici4NZYDaTxNTN55lBEkICmhK3mjvAbE4BLYk3zX9YQWxhgXiJ
	DZObwOIsAqoSh770MYHYvAK2Ej/evGCEsAUlfky+B7aMGah3/c7jTBC2vMTmNW+BejmATlWX
	ePRXF+IGI4n/S2azQZSISOx78Y4R5B4JgUYOiQ0tDawQuwQkvk0+xALRKyux6QAzxMeSEgdX
	3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihMT2xB2M
	9w9YH2JMBlo/kVlKNDkfmBrySuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgt
	ii8qzUktPsTIxMEp1cCov29DysYdnKGr5YPi3G2FJilIZ7e3SH1Ryv369ZzDRWM1E42nGmlu
	vefWVNoKLHn+4vOsq1zb/wW4BX5SuLFQYdNfJtVPsaLGs+Z8N9pkPsGzRDDOYku2SMLMdxMv
	qx35ucXM4hKbwoGM0yuC/u7Ykfdn28y9q2bEZBQsfFvLdvz7cxP+sKpwJZbijERDLeai4kQA
	Vz+OmAMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jAd37xxOCDDqbRSyWNGVYXF54idXi
	Ud9zRotli58yWlzeNYfN4uy842wWlz6dY7RY8nExi8Xmn49ZHDg9Fmwq9Ti6+zeTx8ent1g8
	1n05we7Rt2UVo8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDO+
	PlzCXLBNpqJr3kumBsY1Il2MnBwSAiYSJ96eZ4OwxSQu3FsPZHNxCAksYpTYfGsNM4Tzi1Hi
	zaouFpAqNgE1iS9fDrOD2CICLhLrd4LEuTiYBWYzSUzdfJ4ZJCEkoClxq7kDzOYU0JJ40/yH
	FcQWFoiX2DC5CSzOIqAqcehLHxOIzStgK/HjzQtGCFtQ4sfke2DLmIF61+88zgRhy0tsXvMW
	qJcD6FR1iUd/dSFuMJL4v2Q2G0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC
	4qT0XCO94sTc4tK8dL3k/NxNjODE8Ux6B+OqBotDjAIcjEo8vAe+xQcJsSaWFVfmHmKU4GBW
	EuEtXpIQJMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wKSWVxJvaGxiZmRpZGZhZGJuTpqw
	kjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MzvqyHE/T9YV9vlyS1OK6NzVKU3355mWzr0r2
	T1n5r93a4+rqUwXuKx6YN7ie2cvGvt3XaHvTTt0Hn3TvCFZVPfPu8l48tXqRkytn8VGpr08a
	bA3cFa/uPrFP//ujZSHW+89sWCGSecxdyMpi8nGz/fxsxjyLw1Yy6nwXXKcsck/j7v7GJavT
	lFiKMxINtZiLihMBWJqdSmADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 16, 2013 3:33 PM, Zhenzhong Duan wrote:
> 
> Driver init call graph under baremetal:
> driver_init->
>     msix_capability_init->
>         msix_program_entries->
>             msix_mask_irq->
>                 entry->masked = 1
>     request_irq->
>         __setup_irq->
>             irq_startup->
>                 unmask_msi_irq->
>                     msix_mask_irq->
>                         entry->masked = 0;
> 
> So entry->masked is always updated with newest value and its value could be used
> to restore to mask register in device.
> 
> But in initial domain (aka priviliged guest), it's different.
> Driver init call graph under initial domain:
> driver_init->
>     msix_capability_init->
>         msix_program_entries->
>             msix_mask_irq->
>                 entry->masked = 1
>     request_irq->
>         __setup_irq->
>             irq_startup->
>                 __startup_pirq->
>                     EVTCHNOP_bind_pirq hypercall    (trap into Xen)
> [Xen:]
> pirq_guest_bind->
>     startup_msi_irq->
>         unmask_msi_irq->
>             msi_set_mask_bit->
>                 entry->msi_attrib.masked = 0;
> 
> So entry->msi_attrib.masked in xen side always has newest value. entry->masked
> in initial domain is untouched and is 1 after msix_capability_init.
> 
> Based on above, it's Xen's duty to restore entry->msi_attrib.masked to device,
> but with current code, entry->masked is used and MSI-x interrupt is masked.
> 
> Before patch, restore call graph under initial domain:
> pci_reset_function->
>     pci_restore_state->
>         __pci_restore_msix_state->
>             arch_restore_msi_irqs->
>                 xen_initdom_restore_msi_irqs->
>                     PHYSDEVOP_restore_msi hypercall (first mask restore)
>             msix_mask_irq(entry, entry->masked)     (second mask restore)
> 
> So msix_mask_irq call in initial domain call graph needs to be removed.
> 
> Based on this we can move the restore of the mask in default_restore_msi_irqs
> which would avoid restoring the invalid mask under Xen. Furthermore this
> simplifies the API by making everything related to restoring an MSI be in the
> platform specific APIs instead of just parts of it.
> 
> After patch, restore call graph under initial domain:
> pci_reset_function->
>     pci_restore_state->
>         __pci_restore_msix_state->
>             arch_restore_msi_irqs->
>                 xen_initdom_restore_msi_irqs->
>                     PHYSDEVOP_restore_msi hypercall (first mask restore)
> 
> Logic for baremetal is not changed.
> Before patch, restore call graph under baremetal:
> pci_reset_function->
>     pci_restore_state->
>         __pci_restore_msix_state->
>             arch_restore_msi_irqs->
>                 default_restore_msi_irqs->
>             msix_mask_irq(entry, entry->masked)     (first mask restore)
> 
> After patch, restore call graph under baremetal:
> pci_reset_function->
>     pci_restore_state->
>         __pci_restore_msix_state->
>             arch_restore_msi_irqs->
>                 default_restore_msi_irqs->
>                     msix_mask_irq(entry, entry->masked) (first mask restore)
> 
> The process for MSI code is similiar.
> 
> Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

It looks good. Also, I tested this patch on Exynos5440.

Best regards,
Jingoo Han

