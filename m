Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaDYMdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:33:11 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44781 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752239AbaDYMdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:33:08 -0400
Message-ID: <535A55F7.8030506@arm.com>
Date: Fri, 25 Apr 2014 13:32:55 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 6/7] ARM: rtc: update CMOS RTC to support MMIO and private
 lock
References: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com> <1398418275-9671-7-git-send-email-marc.zyngier@arm.com> <20140425102732.GI26756@n2100.arm.linux.org.uk>
In-Reply-To: <20140425102732.GI26756@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 25/04/14 11:27, Russell King - ARM Linux wrote:
> On Fri, Apr 25, 2014 at 10:31:14AM +0100, Marc Zyngier wrote:
>> So far, the CMOS RTC (PC-style mc146818) has always been used
>> through an ISA I/O port of some sort, with each platform configuring
>> the address in a static way.
>>
>> Some platforms (KVM with kvmtools, for example) offer a MMIO version
>> of the CMOS RTC, which requires a different access method.
>>
>> This patch select the RTC_DRV_CMOS_MMIO configuration in order to
>> support MMIO accesses as well as the older IO port method.
>>
>> While we're at it, switch to RTC_DRV_CMOS_PRIV_LOCK and remove the
>> ancient rtc_lock.
> 
> rtc_lock is there so that if you build the RTC driver and nvram driver
> in, and load them, they will both want to access the RTC via its
> indexed registers, and they need to share the lock to avoid trampling
> on each others toes.

Ah, I completely missed that one. Note to self: never look at that kind
of code just after lunch...

> Yes, it should be handled in a more modern way, but I don't think you
> can simply get rid of this in this manner.  We can have both these
> drivers loaded on ARM platforms.

Agreed. I suppose that would have to be handled by some kind of module
dependency, but it is starting to look even uglier than I initially thought.

Back to the drawing board...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
