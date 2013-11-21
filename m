Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3KUIMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:12:40 -0500
Received: from vistrem1.vector-informatik.com ([217.89.139.138]:53580 "EHLO
	vistrem1.vector-informatik.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab3KUIMi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:12:38 -0500
From: "Frederich, Jens" <Jens.Frederich@vector.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Kernel Panic] 3.10.10-rt7
Thread-Topic: [Kernel Panic] 3.10.10-rt7
Thread-Index: Ac7l66BMdAdPuzbGTZONTbGkPOT5y///8ZsAgAA1n4D//t8WoA==
Date: Thu, 21 Nov 2013 08:12:33 +0000
Message-ID: <9B7F15AA4177464A8FAB5BE79B14288B88968EAB@vistrex3.vi.vector.int>
References: <9B7F15AA4177464A8FAB5BE79B14288B88967CEF@vistrex3.vi.vector.int>
 <528CAC42.1060706@siemens.com> <528CD93D.4060609@windriver.com>
In-Reply-To: <528CD93D.4060609@windriver.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.49.46.146]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Paul Gortmaker [mailto:paul.gortmaker@windriver.com]
>Sent: Wednesday, November 20, 2013 4:46 PM
>To: Jan Kiszka; Frederich, Jens; linux-rt-users@vger.kernel.org
>Cc: linux-kernel@vger.kernel.org
>Subject: Re: [Kernel Panic] 3.10.10-rt7
>
>On 13-11-20 07:34 AM, Jan Kiszka wrote:
>> On 2013-11-20 13:26, Frederich, Jens wrote:
>>> Hello,
>>>
>>> I got a Kernel panic by some long time stress tests. Look here:
>http://dy.cx/pqP7M.
>>
>> Ah, that should be
>http://thread.gmane.org/gmane.linux.kernel/1564783
>>
>> Paul, was there any follow-up patch on this topic?
>
>Yeah, from the rt-summit [ http://lwn.net/Articles/572740/ ] it is on
>me
>to get those simple wait queue patches mainlined (and then the
>local_bh
>stuff).  Once I've got that done, I'll look at spending some time on
>3.12-rt
>kvm patches -- in the meantime, you are right, the screenshot shows
>that his
>3.10-rt needs the straightforward conversion of vpcu->wq to simple
>wait.
>

It's good to hear.

Paul, can you estimate when the kvm patches is ready, so that I can test it? 

thanks
Jens

>Paul.
>--
>
>>
>> Jan
>>
>>>
>>> Furthermore I got sporadic some BUG messages:
>>>
>>> [ 1128.358971] BUG: scheduling while atomic: swapper/0/0/0x00010002
>>> [ 1128.358982] Preemption disabled at:[<ffffffff810dfb8a>]
>cpu_startup_entry+0x17a/0x300
>>>
>>> Hardware
>>> --------
>>>
>>> My system is a i7 with 4 GB RAM congatec evalboard.
>>>
>>> Setup
>>> -----
>>>
>>> On the system runs Linux RT (text mode) 3.10.10-rt7 with 1 GB RAM
>and a
>>> Windows 7 KVM/QEMU (Qemu 1.6.1) guest with 3 GB RAM. Each system
>has it own
>>> ethernet card. The Win 7 guest uses it per pci pass-through. The
>Win 7 is
>>> pinned to core 2,3.
>>>
>>> Scenario
>>> --------
>>>
>>> We sending UDP packages every 1 msec on the Linux side. The UDP
>sender process
>>> has real time prio 80 and the ethernet driver 90. At the same time
>we are
>>> stressing Win 7. Memory stress - allocate as much as possible and
>do memset(),
>>> then CPU stress - high CPU load, then Kernel DPC stress - high load
>thread at
>>> DPC level and ethernet stress - send UDP packages every
>milliseconds. I got the
>>> panic after 45 minutes. It seems that is correlates with the
>ethernet stress.
>>>
>>> Can anybody help me?
>>>
>>> thanks
>>> Jens
>>
