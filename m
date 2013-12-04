Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3LDE4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:56:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35686 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3LDEzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:55:55 -0500
Message-ID: <529EB629.1020605@oracle.com>
Date: Wed, 04 Dec 2013 12:57:13 +0800
From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.24 (X11/20101209)
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] PCI: Introduce two new MSI infrastructure calls for masking/unmasking.
References: <1383772616-23060-1-git-send-email-konrad.wilk@oracle.com> <CAErSpo4rdHwhuF=SM6WT3EP3TGoUFnwxVdx5919qxea3On7MRw@mail.gmail.com> <527C41E9.6040002@oracle.com> <20131108153507.GA24755@phenom.dumpdata.com>
In-Reply-To: <20131108153507.GA24755@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Fri, Nov 08, 2013 at 09:44:09AM +0800, Zhenzhong Duan wrote:
>   
>> On 2013-11-07 07:51, Bjorn Helgaas wrote:
>>     
>>> [+cc Thomas, Ingo, Peter, x86 list]
>>>
>>> On Wed, Nov 6, 2013 at 2:16 PM, Konrad Rzeszutek Wilk
>>> <konrad.wilk@oracle.com> wrote:
>>>       
>>>> Certain platforms do not allow writes in the MSI-X bars
>>>> to setup or tear down vector values. To combat against
>>>> the generic code trying to write to that and either silently
>>>> being ignored or crashing due to the pagetables being marked r/o
>>>> this patch introduces a platform over-write.
>>>>
>>>> Note that we keep two separate, non-weak, functions
>>>> default_mask_msi_irqs() and default_mask_msix_irqs() for the
>>>> behavior of the arch_mask_msi_irqs() and arch_mask_msix_irqs(),
>>>> as the default behavior is needed by x86 PCI code.
>>>>
>>>> For Xen, which does not allow the guest to write to MSI-X
>>>> tables - as the hypervisor is solely responsible for setting
>>>> the vector values - we implement two nops.
>>>>
>>>> CC: Bjorn Helgaas <bhelgaas@google.com>
>>>> CC: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
>>>> CC: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>>>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>>         
>>> I think this is safe, and I'd like to squeeze it into the v3.13 merge
>>> window next week, since it supersedes three patches Zhenzhong has been
>>> trying to get in since July [1], and this patch is much simpler to
>>> understand.
>>>       
>> This patch could replace the first two.
>> I think the third patch of mine is still needed as it does a
>> different thing.
>> It optimizes restore path in dom0.
>>     
>
> I tried to rebase it on top of this patch but it ended up that
> you still need the two arguments (for restore_... operation). 
>
> But perhaps there is a better way. If you can rebase on top
> of this patch - and send it out - that would be great!
>   
Ok, I'll send one rebased on your patch later.

-- 
Regards
zhenzhong
--
Oracle Building, No.24 Building, Zhongguancun Software Park
Haidian District, Beijing 100193, China

