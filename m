Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbbA2PQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:16:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:21526 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbbA2PQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:16:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="447039146"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: RE: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Topic: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Index: AQHQOylqnLZVjTv+WEq44p1GA6waZpzWMk6AgAAoNgCAAAEsAIAAwdXQgAAXoFA=
Date: Thu, 29 Jan 2015 15:15:58 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B732715A94@PGSMSX105.gar.corp.intel.com>
References: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie>
	<1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>
	<20150129074411.GA4817@gmail.com>
 <CAHp75Vfff-C++LWyyK+FWLnot=jO4kQvbDaN9hJ2_VrhG8n2Qg@mail.gmail.com>
 <54CA0782.8000807@nexus-software.ie> 
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

These two patches requires another patch "x86: Re-enable IO-APIC for non-SMP X86_32" 
to be included to make sure we have the right build for Quark.

I tested v6 on Galileo Gen v2 just now. I am happy with it.
Many thanks.

Below are the logs:

root@quark:/proc# dmesg | grep imr
[    3.727884] imr: protecting kernel .text - .rodata: 9240 KiB (c1000000 - c1906000)
[    3.736421] imr_selftest: self_test pass zero sized IMR
[    3.742413] imr_selftest: self_test pass overlapped IMR @ (0xc1000000 - 0xc1906000)
[    3.751164] imr_selftest: self_test pass overlapped IMR @ (0xc1905c00 - 0xc220bc00)
[    3.759916] imr_selftest: self_test pass overlapped IMR @ (0xc0fff400 - 0xc1905400)
[    3.768566] imr_selftest: self_test pass 1KiB IMR @ 0x00000000 - access-all
[    3.776542] imr_selftest: self_test pass 1KiB IMR @ 0x00000000 - cpu access
[    3.784442] imr_selftest: self_test pass index-teardown - cpu access
[    3.791690] imr_selftest: self_test pass 2KiB IMR @ 0x00000000
[    3.798396] imr_selftest: self_test pass index-teardown 2KiB
[    3.804957] imr_selftest: self_test pass 2KiB IMR @ 0x00000000
[    3.811616] imr_selftest: self_test pass addr-teardown 2KiB
root@quark:/proc# cat /sys/kernel/debug/imr_state
imr00: base=0x00000000, end=0x00000000, size=0x00000000 rmask=0xbfffffff, wmask=0xffffffff, disabled, unlocked
imr01: base=0x00000000, end=0x00000000, size=0x00000000 rmask=0xbfffffff, wmask=0xffffffff, disabled, unlocked
imr02: base=0x00000000, end=0x00000000, size=0x00000000 rmask=0xbfffffff, wmask=0xffffffff, disabled, unlocked
imr03: base=0x00000000, end=0x00000000, size=0x00000000 rmask=0xbfffffff, wmask=0xffffffff, disabled, unlocked
imr04: base=0x00000000, end=0x00000000, size=0x00000000 rmask=0xbfffffff, wmask=0xffffffff, disabled, unlocked
imr05: base=0x00000000, end=0x00000000, size=0x00000000 rmask=0xbfffffff, wmask=0xffffffff, disabled, unlocked
imr06: base=0x00000000, end=0x00000000, size=0x00000000 rmask=0xbfffffff, wmask=0xffffffff, disabled, unlocked
imr07: base=0x01000000, end=0x01905fff, size=0x00905fff rmask=0x00000001, wmask=0x00000001, enabled , locked

 

>-----Original Message-----
>From: Ong, Boon Leong
>Sent: Thursday, January 29, 2015 9:47 PM
>To: 'Bryan O'Donoghue'
>Cc: Thomas Gleixner; Ingo Molnar; H. Peter Anvin; x86@kernel.org;
>dvhart@infradead.org; linux-kernel@vger.kernel.org; Andy Shevchenko; Ingo
>Molnar
>Subject: RE: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
>
>Bryan,
>
>Once you have the next revision ready, I would like to test it on my end across
>both Galileo Gen v1 & v2.
>
>Cheers,
>BL
>
>>-----Original Message-----
>>From: Bryan O'Donoghue [mailto:pure.logic@nexus-software.ie]
>>Sent: Thursday, January 29, 2015 6:12 PM
>>To: Andy Shevchenko; Ingo Molnar
>>Cc: Thomas Gleixner; Ingo Molnar; H. Peter Anvin; x86@kernel.org;
>>dvhart@infradead.org; Ong, Boon Leong; linux-kernel@vger.kernel.org
>>Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark
>>X1000
>>
>>On 29/01/15 10:08, Andy Shevchenko wrote:
>>> On Thu, Jan 29, 2015 at 9:44 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>>> * Bryan O'Donoghue <pure.logic@nexus-software.ie> wrote:
>>>
>>> []
>>>
>>>> In any case, I don't see any major problems with this code, so if
>>>> it's fixed it could go into v3.20.
>>>
>>> Brian, it would be really nice to have it in 3.20 since we have
>>> several drivers already in upstream or be ready for 3.20.
>>> It would be then first upstream kernel with minimal Quark support.
>>
>>NP lads - I'll get a patch out today

