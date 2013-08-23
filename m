Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3HWJ5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:57:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41717 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab3HWJ5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:57:16 -0400
Message-ID: <5217321B.6060306@arm.com>
Date: Fri, 23 Aug 2013 10:57:47 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 0/6] ARM/ARM64 architected timer updates
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <5213A40C.6060509@arm.com> <20130823092610.GB20186@darko.cambridge.arm.com>
In-Reply-To: <20130823092610.GB20186@darko.cambridge.arm.com>
X-OriginalArrivalTime: 23 Aug 2013 09:57:14.0035 (UTC) FILETIME=[24955030:01CE9FE7]
X-MC-Unique: 113082310571404601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/13 10:26, Catalin Marinas wrote:
> On Tue, Aug 20, 2013 at 06:14:52PM +0100, Sudeep KarkadaNagesha wrote:
>> On 13/08/13 18:29, Sudeep KarkadaNagesha wrote:
>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>
>>> This patch series adds support to configure the rate and enable the
>>> event stream for architected timer. The event streams can be used to
>>> impose a timeout on a WFE, to safeguard against any programming error
>>> in case an expected event is not generated or even to implement
>>> wfe-based timeouts for userspace locking implementations.
>>>
>>> Since the timer control register is reset to zero on warm boot, CPU
>>> PM notifier is added to re-initialize it.
>>>
>>> Changes v2->v3:
>>> 1. Moved ARM and ARM64 changes into separate patches
>>> 2. Added native hwcaps definations(ARM/ARM64) and compat-specific
>>>    definitions(ARM64) to the users for the event stream feature. 
>>
>> Can you review this version of the series ?
> 
> I think the series is OK with the follow-up comments addressed. Could
> you please post a v4 to make sure I haven't missed anything?
> 
> Another comment I have is whether we should make this feature
> configurable. The reason is mainly hardware validation: if some CPU
> implementation messes the event generation (and on ARMv8 it's a bit more
> complex as this is tied to the exclusive monitor) we risk not detecting
> it because of the event stream.

Yes that seems reasonable. I assume we can enable it by default and we
need to disable it for hardware validation. Let me know if think otherwise.

Regards,
Sudeep

