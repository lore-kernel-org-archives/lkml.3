Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3LPJGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:06:35 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:23570 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3LPJGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:06:34 -0500
Message-ID: <52AEC241.1040507@huawei.com>
Date: Mon, 16 Dec 2013 17:05:05 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Wei Yang <weiyang@linux.vnet.ibm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Scott Wood <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 6/9] powerpc/pci: Use dev_is_pci() to check whether it
 is pci device
References: <1386244880-22300-1-git-send-email-wangyijing@huawei.com> <20131216071305.GA16842@weiyang.vnet.ibm.com>
In-Reply-To: <20131216071305.GA16842@weiyang.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/16 15:13, Wei Yang wrote:
> Yijing,
> 
> This one looks good.
> 
> While I take a look at the source code, there are around 20 places with
> similar style. Do you think it would be good to change all these places
> in one patch?

I sent the other similar changes to related maillist, some of them (David, Greg )has been accepted,
and other is not. :)

eg.
http://article.gmane.org/gmane.linux.kernel/1608341/match=dev_is_pci

Thanks!
Yijing.

> 
> On Thu, Dec 05, 2013 at 08:01:20PM +0800, Yijing Wang wrote:
>> Use PCI standard marco dev_is_pci() instead of directly compare
>> pci_bus_type to check whether it is pci device.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>> arch/powerpc/sysdev/fsl_pci.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
>> index 4dfd61d..7066e52 100644
>> --- a/arch/powerpc/sysdev/fsl_pci.c
>> +++ b/arch/powerpc/sysdev/fsl_pci.c
>> @@ -122,7 +122,7 @@ static int fsl_pci_dma_set_mask(struct device *dev, u64 dma_mask)
>> 	 * address width of the SoC such that we can address any internal
>> 	 * SoC address from across PCI if needed
>> 	 */
>> -	if ((dev->bus == &pci_bus_type) &&
>> +	if ((dev_is_pci(dev)) &&
>> 	    dma_mask >= DMA_BIT_MASK(MAX_PHYS_ADDR_BITS)) {
>> 		set_dma_ops(dev, &dma_direct_ops);
>> 		set_dma_offset(dev, pci64_dma_offset);
>> -- 
>> 1.7.1
>>
>>
>> _______________________________________________
>> Linuxppc-dev mailing list
>> Linuxppc-dev@lists.ozlabs.org
>> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 


-- 
Thanks!
Yijing

