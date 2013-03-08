Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab3CHGgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:36:14 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:33743 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3CHGgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:36:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUtDcwJkPMPfjur8LQ+u0Hc2J7sbxC=xkcemqRQ1_Gd8g@mail.gmail.com>
References: <51397D1D.5030602@redhat.com>
	<1750036321.11235774.1362722613994.JavaMail.root@redhat.com>
	<CAE9FiQUtDcwJkPMPfjur8LQ+u0Hc2J7sbxC=xkcemqRQ1_Gd8g@mail.gmail.com>
Date: Thu, 7 Mar 2013 22:36:12 -0800
X-Google-Sender-Auth: T_3ZPuyoPZW9I9R7x3RihlvXfEQ
Message-ID: <CAE9FiQU7ccdWCL=t=Zn1w33GHpHk56=JXTcotn-Huq9Wiqu7wg@mail.gmail.com>
Subject: Re: 3.9-rc1: crash kernel panic - not syncing: Can not allocate
 SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer
From: Yinghai Lu <yinghai@kernel.org>
To: CAI Qian <caiqian@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kexec <kexec@lists.infradead.org>,
        Dave Young <dyoung@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        WANG Chao <chaowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 10:32 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Mar 7, 2013 at 10:03 PM, CAI Qian <caiqian@redhat.com> wrote:
>> CC'ing kexec ML. Also mentioned that 3.8 has no such issue.
>>
>> This message looks suspicious and out of range while 3.8 reservation
>> looks within the range.
>>
>> [    0.000000] Reserving 128MB of memory at 5216MB for crashkernel
>> (System RAM: 3977MB)
>>
>> Wondering if anything to do with memblock again...
>
> that is intended...
>
>> ----- Original Message -----
>>> From: "WANG Chao" <chaowang@redhat.com>
>>> To: "LKML" vger.kernel.org>
>>> Cc: "CAI Qian" <caiqian@redhat.com>
>>> Sent: Friday, March 8, 2013 1:54:37 PM
>>> Subject: 3.9-rc1: crash kernel panic - not syncing: Can not allocate SWIOTLB buffer earlier and can't now provide you
>>> with the DMA bounce buffer
>>>
>>> Hi, All
>>>
>>> On 3.9-rc1, I load crash kernel with latest kexec-tools(up to
>>> 28d413a), but
>>> 2nd kernel panic at early time:
>>> [    2.948076] Kernel panic - not syncing: Can not allocate SWIOTLB
>>> buffer earlier and can't now provide you with the DMA bounce buffer
>>> [    2.959958] Pid: 53, comm: khubd Not tainted 3.9.0-rc1+ #1
>
> You need to add crashkernel_low=64M in first kernel.
>
> As your system does not support DMA remapping.

looks like your system DO have DMAR table, please enable dmar
remapping in your kernel config.

Yinghai
