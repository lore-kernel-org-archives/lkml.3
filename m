Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3G1D3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 23:29:30 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45094 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3G1D33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 23:29:29 -0400
References: <1374953558-4704-1-git-send-email-ethan.kernel@gmail.com> <7F52345F-242F-4A9D-8CD2-5805936ABAEE@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <7F52345F-242F-4A9D-8CD2-5805936ABAEE@gmail.com>
Content-Type: text/plain;
	charset=GB2312
Content-Transfer-Encoding: 8BIT
Message-Id: <77E02B89-C51A-4CCA-81ED-851F87A44EF5@gmail.com>
Cc: "bhelgaas@google.com" <bhelgaas@google.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>,
        "ethan.zhao" <ethan.zhao@oracle.com>
X-Mailer: iPad Mail (10B329)
From: ethan <ethan.kernel@gmail.com>
Subject: Re: [PATCH V2] x86/PCI: MMCONFIG: cleanup and add address warning to pci_mmconfig_insert
Date: Sun, 28 Jul 2013 11:29:19 +0800
To: Mark D Rustad <mrustad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks£¬got it ,you are right.


ÔÚ 2013-7-28£¬11:09£¬Mark D Rustad <mrustad@gmail.com> Ð´µÀ£º

> Another nit below:
> 
> On Jul 27, 2013, at 12:32 PM, ethan.kernel@gmail.com wrote:
> 
>> Cleanup the -EINVAL return value handling and add warning message for invalid
>> start,end,addr parameters.
>> 
>> V2: Corrected code style and tested for Linux v 3.11-rc2
>> 
>> Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
>> ---
>> arch/x86/pci/mmconfig-shared.c |   12 ++++++------
>> 1 files changed, 6 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
>> index 082e881..37f6c7f 100644
>> --- a/arch/x86/pci/mmconfig-shared.c
>> +++ b/arch/x86/pci/mmconfig-shared.c
>> @@ -700,8 +700,13 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
>>    if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
>>        return -ENODEV;
>> 
>> -    if (start > end)
>> +    if (start > end || !addr) {
>> +        dev_warn(dev, FW_INFO
>> +            "Invalid address to add MMCONFIG"
>> +            "start %02x end %02x addr %pR\n",
> 
> As it is here, there will be no space between MMCONFIG and the word start. Better still, put the entire string on one line to aid those searching for the message. There is a general exception to the 80-column rule for user-visible messages such as this.
> 
> <snip>
> 
> -- 
> Mark Rustad, MRustad@gmail.com
> 
