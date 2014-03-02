Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaCBBrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 20:47:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:59083 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaCBBrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 20:47:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,570,1389772800"; 
   d="scan'208";a="492272072"
Message-ID: <53128DA0.9060105@linux.intel.com>
Date: Sun, 02 Mar 2014 09:47:12 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg59@srcf.ucam.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53102AB9.40600@linux.intel.com> <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com> <20140228064413.GA4900@srcf.ucam.org> <531032A0.8090903@linux.intel.com> <5310CBB7.4030407@linux.intel.com> <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org> <53123DCF.7040500@zytor.com> <20140301202139.GA9759@srcf.ucam.org> <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com> <53127AA7.8040700@linux.intel.com> <53127C4B.1060505@zytor.com>
In-Reply-To: <53127C4B.1060505@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/2 8:33, H. Peter Anvin wrote:
> On 03/01/2014 04:26 PM, Li, Aubrey wrote:
>>>
>>> On March 1, 2014 12:21:39 PM PST, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>>> if we've hit the keyboard controller and ACPI twice, and the system is still alive, and 
>>>> if we have standard PCI ports, 
>>
>>>> it doesn't seem like poking them is likely to make anything actively
>> worse.
>>>
>> This is exactly what I'm trying to express. thanks Matt. It doesn't make
>> anything worse, it makes reboot working on some systems.
>>
>> On 2014/3/2 4:26, H. Peter Anvin wrote:
>>> True... trying cf9_cond with low priority probably makes sense.
>>
>> I'm not asking CF9 only, I'm asking all of the known method in reboot.c.
>> So, BIOS is appliable as well with the same logic and with low priority,
>> isn't it?
>>
> 
> The problem comes in when a method doesn't just not work, but hangs the
> machine.

If we don't do this, the machine hangs there as well. Again, we does not
make things worse.

> BIOS *WILL* hang the machine if it doesn't work.  CF9 has been
> known to hang the machine.
>

Since we are not able to make things worse, let's make it better. So
Let's dig into this. For the machine hangs by CF9, it's known to work by
KBD, right? For the machine hangs by BIOS, do you know which method will
make reboot work?

The answer will determine the sequence of the list. If BIOS hangs but
either of ACPI/KBD/EFI/CF9 works, BIOS is behind of those ways. If BIOS
hangs, no any other way can make it work. BIOS is still the last way.

If CF9 hangs while ACPI/KBD hangs as well, and BIOS happened to work(do
we really have one?), the above list still doesn't make things worse,
reboot=b and dmidecode table still work.

Thanks,
-Aubrey
