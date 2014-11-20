Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaKTLmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:42:36 -0500
Received: from smtp.citrix.com ([66.165.176.89]:41934 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaKTLmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:42:35 -0500
X-IronPort-AV: E=Sophos;i="5.07,423,1413244800"; 
   d="scan'208";a="193229891"
Message-ID: <546DD3A8.2060404@citrix.com>
Date: Thu, 20 Nov 2014 11:42:32 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <xen-devel@lists.xenproject.org>, Thomas Gleixner <tglx@linutronix.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH 4/4] x86/xen: use the maximum MFN to calculate
 the required DMA mask
References: <1416412921-23671-1-git-send-email-david.vrabel@citrix.com> <1416412921-23671-5-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1411191749110.12596@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1411191749110.12596@kaball.uk.xensource.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/11/14 17:51, Stefano Stabellini wrote:
> On Wed, 19 Nov 2014, David Vrabel wrote:
>> 
>> +u64
>> +xen_swiotlb_get_required_mask(struct device *dev)
>> +{
>> +	unsigned long max_mfn;
>> +
>> +	max_mfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
> 
> As Jan pointed out, I think you need to change the prototype of
> HYPERVISOR_memory_op to return long. Please do consistently across all
> relevant archs.

This doesn't help since 32-bit guests will still truncate.  A new
hypercall op that returns the result in a uint64_t parameter is required.

There is another reason why max_mfn isn't suitable -- IOMMU usage so I
think we should assume a 64-bit DMA mask is required (this is actually
the change I put into XenServer's kernel).

David
