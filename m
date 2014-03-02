Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaCBCU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 21:20:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:38146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaCBCUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 21:20:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,570,1389772800"; 
   d="scan'208";a="492277366"
Message-ID: <53129555.7020307@linux.intel.com>
Date: Sun, 02 Mar 2014 10:20:05 +0800
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
References: <53102AB9.40600@linux.intel.com> <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com> <20140228064413.GA4900@srcf.ucam.org> <531032A0.8090903@linux.intel.com> <5310CBB7.4030407@linux.intel.com> <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org> <53123DCF.7040500@zytor.com> <20140301202139.GA9759@srcf.ucam.org> <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com> <53127AA7.8040700@linux.intel.com> <53127C4B.1060505@zytor.com> <53128DA0.9060105@linux.intel.com> <53129256.6060704@zytor.com>
In-Reply-To: <53129256.6060704@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/2 10:07, H. Peter Anvin wrote:
> On 03/01/2014 05:47 PM, Li, Aubrey wrote:
>>
>> Since we are not able to make things worse, let's make it better. So
>> Let's dig into this. For the machine hangs by CF9, it's known to work by
>> KBD, right? For the machine hangs by BIOS, do you know which method will
>> make reboot work?
>>
> 
> No.
> 
>> The answer will determine the sequence of the list. If BIOS hangs but
>> either of ACPI/KBD/EFI/CF9 works, BIOS is behind of those ways. If BIOS
>> hangs, no any other way can make it work. BIOS is still the last way.
>>
>> If CF9 hangs while ACPI/KBD hangs as well, and BIOS happened to work(do
>> we really have one?), the above list still doesn't make things worse,
>> reboot=b and dmidecode table still work.
> 
> We obviously have been over this a number of times.

This time is different, we won't touch the existing behavior, we add
success probability after that.

> and the sad thing is that we have very limited information.  It is more complex
> than that,even... I believe in some cases KBD works but it is slow,
and so takes a
> while.

This makes me to stop to consider to remove the existing dmidecode table
to be safe. But a more robust list will prevent us to add more quirks.
As long as we do not touch existing behavior, we reduce the number of
reboot hang machines in the world.

Does this make sense?

Thanks,
-Aubrey

> 
> 	-hpa
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
