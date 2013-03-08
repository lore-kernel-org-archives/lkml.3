Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3CHHVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:21:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab3CHHVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:21:04 -0500
Message-ID: <51399154.5030500@redhat.com>
Date: Fri, 08 Mar 2013 15:20:52 +0800
From: WANG Chao <chaowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kexec <kexec@lists.infradead.org>, Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 3.9-rc1: crash kernel panic - not syncing: Can not allocate SWIOTLB
 buffer earlier and can't now provide you with the DMA bounce buffer
References: <51397D1D.5030602@redhat.com> <1750036321.11235774.1362722613994.JavaMail.root@redhat.com> <CAE9FiQUtDcwJkPMPfjur8LQ+u0Hc2J7sbxC=xkcemqRQ1_Gd8g@mail.gmail.com> <CAE9FiQU7ccdWCL=t=Zn1w33GHpHk56=JXTcotn-Huq9Wiqu7wg@mail.gmail.com>
In-Reply-To: <CAE9FiQU7ccdWCL=t=Zn1w33GHpHk56=JXTcotn-Huq9Wiqu7wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 02:36 PM, Yinghai Lu wrote:
> On Thu, Mar 7, 2013 at 10:32 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Thu, Mar 7, 2013 at 10:03 PM, CAI Qian <caiqian@redhat.com> wrote:
>>> CC'ing kexec ML. Also mentioned that 3.8 has no such issue.
>>>
>>> This message looks suspicious and out of range while 3.8 reservation
>>> looks within the range.
>>>
>>> [    0.000000] Reserving 128MB of memory at 5216MB for crashkernel
>>> (System RAM: 3977MB)
>>>
>>> Wondering if anything to do with memblock again...
>>
>> that is intended...
>>
>>> ----- Original Message -----
>>>> From: "WANG Chao" <chaowang@redhat.com>
>>>> To: "LKML" vger.kernel.org>
>>>> Cc: "CAI Qian" <caiqian@redhat.com>
>>>> Sent: Friday, March 8, 2013 1:54:37 PM
>>>> Subject: 3.9-rc1: crash kernel panic - not syncing: Can not allocate SWIOTLB buffer earlier and can't now provide you
>>>> with the DMA bounce buffer
>>>>
>>>> Hi, All
>>>>
>>>> On 3.9-rc1, I load crash kernel with latest kexec-tools(up to
>>>> 28d413a), but
>>>> 2nd kernel panic at early time:
>>>> [    2.948076] Kernel panic - not syncing: Can not allocate SWIOTLB
>>>> buffer earlier and can't now provide you with the DMA bounce buffer
>>>> [    2.959958] Pid: 53, comm: khubd Not tainted 3.9.0-rc1+ #1
>>
>> You need to add crashkernel_low=64M in first kernel.
>>
>> As your system does not support DMA remapping.
> 
> looks like your system DO have DMAR table, please enable dmar
> remapping in your kernel config.

I've already got following config:
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_IRQ_REMAP=y

but I don't have intel_iommu=on in kernel cmdline. IIRC, iommu will prevent
2nd kernel from booting ...

I tested crashkernel=128M and crashkernel_low=64M, seems 2nd-kernel/kexec only
works when two params are used in combination.

Thanks,
WANG Chao

> 
> Yinghai
> 
