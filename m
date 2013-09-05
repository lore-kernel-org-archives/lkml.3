Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab3IEGex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 02:34:53 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:64521 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab3IEGev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 02:34:51 -0400
Message-ID: <522825E3.9050806@huawei.com>
Date: Thu, 5 Sep 2013 14:34:11 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 4/7] x86/pci: use pcie_cap to simplify code
References: <1378193715-25328-1-git-send-email-wangyijing@huawei.com> <1378193715-25328-4-git-send-email-wangyijing@huawei.com> <20130904025940.GD24733@google.com>
In-Reply-To: <20130904025940.GD24733@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/4 10:59, Bjorn Helgaas wrote:
> On Tue, Sep 03, 2013 at 03:35:12PM +0800, Yijing Wang wrote:
>> PCI core saves PCIe Cap offset in pcie_cap,
>> use pcie_cap to simplify code.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  arch/x86/pci/fixup.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
>> index f5809fa..ee8330d 100644
>> --- a/arch/x86/pci/fixup.c
>> +++ b/arch/x86/pci/fixup.c
>> @@ -288,7 +288,7 @@ static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
>>  		 */
>>  		list_for_each_entry(dev, &pbus->devices, bus_list) {
>>  			/* There are 0 to 8 devices attached to this bus */
>> -			cap_base = pci_find_capability(dev, PCI_CAP_ID_EXP);
>> +			cap_base = dev->pcie_cap;
>>  			quirk_aspm_offset[GET_INDEX(pdev->device, dev->devfn)] = cap_base + 0x10;
> 
> This should use PCI_EXP_LNKCTL instead of "0x10".
> 
>>  		}
>>  		pbus->ops = &quirk_pcie_aspm_ops;

Hi Bjorn,
   Thanks for your review and comments!

> 
> This quirk replaces the config accessors with ones that silently ignore
> writes to ASPM control bits.  That really warrants at least a dev_info()
> note here, and we should be using pci_bus_set_ops().

Good idea, I will update it, thanks!

> 
> Even that is a little bit dubious because I don't think this is really
> safe -- what happens if this quirk replaces the ops, then somebody
> else replaces the ops again?  aer_inject.c at least keeps track of
> the old ops and seems to fall back to them, but it seems fragile to
> depend on every caller of pci_bus_set_ops() to do the right thing
> there.
> 
> But this is beyond the scope of your patch, so if you just
> add a dev_info() note and use pci_bus_set_ops(), that should be
> enough for now.
> 
> 


-- 
Thanks!
Yijing

