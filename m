Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3KTPqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:46:16 -0500
Received: from mail1.windriver.com ([147.11.146.13]:35399 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KTPqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:46:15 -0500
Message-ID: <528CD93D.4060609@windriver.com>
Date: Wed, 20 Nov 2013 10:46:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>,
        "Frederich, Jens" <Jens.Frederich@vector.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Kernel Panic] 3.10.10-rt7
References: <9B7F15AA4177464A8FAB5BE79B14288B88967CEF@vistrex3.vi.vector.int> <528CAC42.1060706@siemens.com>
In-Reply-To: <528CAC42.1060706@siemens.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-11-20 07:34 AM, Jan Kiszka wrote:
> On 2013-11-20 13:26, Frederich, Jens wrote:
>> Hello,
>>
>> I got a Kernel panic by some long time stress tests. Look here: http://dy.cx/pqP7M.
> 
> Ah, that should be http://thread.gmane.org/gmane.linux.kernel/1564783
> 
> Paul, was there any follow-up patch on this topic?

Yeah, from the rt-summit [ http://lwn.net/Articles/572740/ ] it is on me
to get those simple wait queue patches mainlined (and then the local_bh
stuff).  Once I've got that done, I'll look at spending some time on 3.12-rt
kvm patches -- in the meantime, you are right, the screenshot shows that his
3.10-rt needs the straightforward conversion of vpcu->wq to simple wait.

Paul.
--

> 
> Jan
> 
>>
>> Furthermore I got sporadic some BUG messages:
>>
>> [ 1128.358971] BUG: scheduling while atomic: swapper/0/0/0x00010002
>> [ 1128.358982] Preemption disabled at:[<ffffffff810dfb8a>] cpu_startup_entry+0x17a/0x300
>>
>> Hardware
>> --------
>>
>> My system is a i7 with 4 GB RAM congatec evalboard.
>>
>> Setup
>> -----
>>
>> On the system runs Linux RT (text mode) 3.10.10-rt7 with 1 GB RAM and a
>> Windows 7 KVM/QEMU (Qemu 1.6.1) guest with 3 GB RAM. Each system has it own
>> ethernet card. The Win 7 guest uses it per pci pass-through. The Win 7 is
>> pinned to core 2,3.
>>
>> Scenario
>> --------
>>
>> We sending UDP packages every 1 msec on the Linux side. The UDP sender process
>> has real time prio 80 and the ethernet driver 90. At the same time we are
>> stressing Win 7. Memory stress - allocate as much as possible and do memset(),
>> then CPU stress - high CPU load, then Kernel DPC stress - high load thread at
>> DPC level and ethernet stress - send UDP packages every milliseconds. I got the
>> panic after 45 minutes. It seems that is correlates with the ethernet stress.
>>
>> Can anybody help me?
>>
>> thanks
>> Jens
> 
