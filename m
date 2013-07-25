Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab3GYWnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:43:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37499 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514Ab3GYWnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:43:14 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130725200551.GA16719@gmail.com>
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org> <20130725200551.GA16719@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Ugly patches for stolen reservation
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 25 Jul 2013 15:42:25 -0700
To: Ingo Molnar <mingo@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org
Message-ID: <5304d042-6f8f-4754-9d19-df62662d19f4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the bootloader is just as likely to step on things... what happens when/if it does?

Ingo Molnar <mingo@kernel.org> wrote:
>
>* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
>> Patch 2/2 has the description, but suffice it to say I'm 
>> not really pleased with this, though it does solve a 
>> problem we have.  On some machines, we get MMIO space 
>> allocated on top of this hidden memory, which can cause 
>> problems.  I'm not sure if there are similar problems for 
>> other hunks of the address space; if so it's possible 
>> this could be made more general (though the bits for 
>> looking up the address of this region are definitely 
>> Intel graphics specific).
>
>It looks pretty hardware specific. Discovering it the hard 
>way and marking it e820 reserved in an early quirk is what 
>the firmware should have done to begin with - and I doubt 
>the kernel could do anything significantly cleaner.
>
>How does Windows manage to not crash? By luckily never 
>allocating PCI resources on top of the RAM? Or does it have 
>a quirk?
>
>> Chris has some patches on top to add a new E820 type so 
>> we can look up the region later, which removes some 
>> redundant code in the i915 driver at least.
>> 
>> Any comments?  I assume no one likes this, but maybe it's 
>> just another early quirk we'll have to live with...
>
>No strong feelings against it - my only suggestion would be 
>to make this more visible - right now it's added as e820 
>reserved which hides amongst other areas already marked 
>reserved - would a low-key printk() of the range added make 
>it more apparent that a kernel quirk activated here?
>
>Just so that people know that it came from the kernel, not 
>the firmware.
>
>But in any case:
>
>Acked-by: Ingo Molnar <mingo@kernel.org>
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
