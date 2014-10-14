Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbaJNQRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:17:38 -0400
Received: from smtp.citrix.com ([66.165.176.89]:21406 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522AbaJNQRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:17:33 -0400
X-IronPort-AV: E=Sophos;i="5.04,718,1406592000"; 
   d="scan'208";a="181204593"
Message-ID: <543D4B5C.2040502@citrix.com>
Date: Tue, 14 Oct 2014 17:12:12 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <Ian.Campbell@citrix.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 6/7] xen/arm/arm64: introduce xen_arch_need_swiotlb
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com> <1412941908-5850-6-git-send-email-stefano.stabellini@eu.citrix.com> <20141014160352.GF30965@laptop.dumpdata.com>
In-Reply-To: <20141014160352.GF30965@laptop.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/14 17:03, Konrad Rzeszutek Wilk wrote:
> On Fri, Oct 10, 2014 at 12:51:47PM +0100, Stefano Stabellini wrote:
>> Introduce an arch specific function to find out whether a particular dma
>> mapping operation needs to bounce on the swiotlb buffer.
>>
>> On ARM and ARM64, if the page involved is a foreign page and the device
>> is not coherent, we need to bounce because at unmap time we cannot
>> execute any required cache maintenance operations (we don't know how to
>> find the pfn from the mfn).
...
>> --- a/arch/x86/include/asm/xen/page.h
>> +++ b/arch/x86/include/asm/xen/page.h
>> @@ -236,4 +236,11 @@ void make_lowmem_page_readwrite(void *vaddr);
>>  #define xen_remap(cookie, size) ioremap((cookie), (size));
>>  #define xen_unmap(cookie) iounmap((cookie))
>>  
>> +static inline bool xen_arch_need_swiotlb(struct device *dev,
>> +		                                 unsigned long pfn,
>> +										 unsigned long mfn)
>> +{
>> +	return false;
>> +}
> 
> Why not make this an macro?

Because macros are evil and inline functions are preferred.

David
