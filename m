Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaHYJDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:03:11 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:65247 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaHYJDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:03:10 -0400
Message-ID: <53FAFBBC.3070100@huawei.com>
Date: Mon, 25 Aug 2014 17:02:52 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Rostislav Lisovy <lisovy@gmail.com>, Sasha Levin <sashal@kernel.org>
CC: Russell King <linux@arm.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicholas Krause <xerofoify@gmail.com>
Subject: Re: [PATCH] ARM: PCI: Use PCI_CLASS_* defines for PCI class
References: <1406904671-19197-1-git-send-email-lisovy@gmail.com>	 <53DE3629.2020706@kernel.org> <1407144668.21386.8.camel@umadbro> <1408955976.8665.23.camel@umadbro>
In-Reply-To: <1408955976.8665.23.camel@umadbro>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/25 16:39, Rostislav Lisovy wrote:
> On Mon, 2014-08-04 at 11:31 +0200, Rostislav Lisovy wrote:
>> On Sun, 2014-08-03 at 09:16 -0400, Sasha Levin wrote:
>>>> -     /* FIXME: add defines for class 0x68000 and 0x80103 */
>>>>       if ((dev->class >> 8) == PCI_CLASS_BRIDGE_HOST ||
>>>> -         dev->class == 0x68000 ||
>>>> -         dev->class == 0x80103) {
>>>> +         dev->class == (PCI_CLASS_BRIDGE_OTHER << 8) ||
>>>> +         dev->class == ((PCI_CLASS_SYSTEM_DMA << 8) | 0x03)) {
>>>>               for (i = 0; i < PCI_NUM_RESOURCES; i++) {
>>>>                       dev->resource[i].start = 0;
>>>>                       dev->resource[i].end   = 0;
>>>>
>>>
>>> Care to explain how your new code is equivalent to the old one?
>>
>> The header file include/linux/pci_ids.h defines
>> #define PCI_CLASS_BRIDGE_OTHER          0x0680
>> #define PCI_CLASS_SYSTEM_DMA            0x0801
>>
>> ((struct pci_dev*)dev)->class
>> corresponds to the 3 bytes Class code in the PCI Configuration space
>> header -- 1B Base class, 1B Sub-class, 1B Reg-level interface.
>>
>> In that case
>> (PCI_CLASS_BRIDGE_OTHER << 8)
>> is equivalent to 0x68000 (imagine the leading zero)
>> and
>> ((PCI_CLASS_SYSTEM_DMA << 8) | 0x03))
>> is equivalent to 0x80103.
>>
> 
> Just a kind reminder in case anyone is interested in reviewing and
> accepting the patch.

Reviewed-by : Yijing Wang <wangyijing@huawei.com>

> 
> Best regards;
> Rostislav Lisovy
> 
> 
> 
> .
> 


-- 
Thanks!
Yijing

