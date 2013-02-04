Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3BDGn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:43:26 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57097 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3BDGnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:43:25 -0500
Message-ID: <510F5881.7030409@linux.vnet.ibm.com>
Date: Mon, 04 Feb 2013 14:43:13 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH 0/3] Enable multiple MSI feature in pSeries
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com> <1359948180.25414.11.camel@concordia> <510F2FDB.6020303@linux.vnet.ibm.com> <1359957375.25414.31.camel@concordia>
In-Reply-To: <1359957375.25414.31.camel@concordia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020406-5490-0000-0000-000002EA2CB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/4 13:56, Michael Ellerman:
> On Mon, 2013-02-04 at 11:49 +0800, Mike Qiu wrote:
>>> On Tue, 2013-01-15 at 15:38 +0800, Mike Qiu wrote:
>>>> Currently, multiple MSI feature hasn't been enabled in pSeries,
>>>> These patches try to enbale this feature.
>>> Hi Mike,
>>>
>>>> These patches have been tested by using ipr driver, and the driver patch
>>>> has been made by Wen Xiong <wenxiong@linux.vnet.ibm.com>:
>>> So who wrote these patches? Normally we would expect the original author
>>> to post the patches if at all possible.
>> Hi Michael
>>
>> These Multiple MSI patches were wrote by myself, you know this feature
>> has not enabled
>> and it need device driver to test whether it works suitable. So I test
>> my patches use
>> Wen Xiong's ipr patches, which has been send out to the maillinglist.
>>
>> I'm the original author :)
> Ah OK, sorry, that was more or less clear from your mail but I just
> misunderstood.
>
>>>> [PATCH 0/7] Add support for new IBM SAS controllers
>>> I would like to see the full series, including the driver enablement.
>> Yep, but the driver patches were wrote by Wen Xiong and has been send
>> out.
> OK, you mean this series?
>
> http://thread.gmane.org/gmane.linux.scsi/79639
Yes, exactly.
>
>
>> I just use her patches to test my patches. all device support Multiple
>> MSI can use my feature not only IBM SAS controllers, I also test my
>> patches use the broadcom wireless card tg3, and also works OK.
> You mean drivers/net/ethernet/broadcom/tg3.c ? I don't see where it
> calls pci_enable_msi_block() ?
Yes, I just modify the driver to support mutiple MSI.
>
> All devices /can/ use it, but the driver needs to be updated. Currently
> we have two drivers that do so (in Linus' tree), plus the updated IPR.
Not all devices, just the device which support the multiple MSI by hardware,
can use it
>
>>>> Test platform: One partition of pSeries with one cpu core(4 SMTs) and
>>>>                 RAID bus controller: IBM PCI-E IPR SAS Adapter (ASIC) in POWER7
>>>> OS version: SUSE Linux Enterprise Server 11 SP2  (ppc64) with 3.8-rc3 kernel
>>>>
>>>> IRQ 21 and 22 are assigned to the ipr device which support 2 mutiple MSI.
>>>>
>>>> The test results is shown by 'cat /proc/interrups':
>>>>            CPU0       CPU1       CPU2       CPU3
>>>> 21:          6          5          5          5      XICS Level     host1-0
>>>> 22:        817        814        816        813      XICS Level     host1-1
>>> This shows that you are correctly configuring two MSIs.
>>>
>>> But the key advantage of using multiple interrupts is to distribute load
>>> across CPUs and improve performance. So I would like to see some
>>> performance numbers that show that there is a real benefit for all the
>>> extra complexity in the code.
>> Yes, the system just has suport two MSIs. Anyway, I will try to do
>> some proformance test, to show the real benefit.
>> But actually it needs the driver to do so. As the data show above, it
>> seems there is some problems in use the interrupt, the irq 21 use few,
>> most use 22, I will discuss with the driver author to see why and if
>> she fixed, I will give out the proformance result.
> Yeah that would be good.
>
> I really dislike that we have a separate API for multi-MSI vs MSI-X, and
> pci_enable_msi_block() also pushes the contiguous power-of-2 allocation
> into the irq domain layer, which is unpleasant. So if we really must do
> multi-MSI I would like to do it differently.
Yes, but the multi-MSI must need the hardware support, it is one extend 
for MSI,
The device may sopport MSI and multiple MSI, but not support MSI-X.
for these devices, we'd better use multiple MSI to makes it more efficiency,
compare with MSI.

multi-MSI just can use no more than 32 interrupts

Thanks
>
> cheers
>
>

