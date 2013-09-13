Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3IMI0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:26:01 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:35538 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3IMIZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:25:58 -0400
Message-ID: <5232CC15.8090208@linaro.org>
Date: Fri, 13 Sep 2013 10:25:57 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] tick: broadcast: Deny per-cpu clockevents from being
 broadcast sources
References: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com> <1379004640-15117-2-git-send-email-soren.brinkmann@xilinx.com> <alpine.DEB.2.02.1309122224420.4089@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1309122224420.4089@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:30 PM, Thomas Gleixner wrote:
> On Thu, 12 Sep 2013, Soren Brinkmann wrote:
>> From: Stephen Boyd <sboyd@codeaurora.org>
>>
>> On most ARM systems the per-cpu clockevents are truly per-cpu in
>> the sense that they can't be controlled on any other CPU besides
>> the CPU that they interrupt. If one of these clockevents were to
>> become a broadcast source we will run into a lot of trouble
>> because the broadcast source is enabled on the first CPU to go
>> into deep idle (if that CPU suffers from FEAT_C3_STOP) and that
>> could be a different CPU than what the clockevent is interrupting
>> (or even worse the CPU that the clockevent interrupts could be
>> offline).
>>
>> Theoretically it's possible to support per-cpu clockevents as the
>> broadcast source but so far we haven't needed this and supporting
>> it is rather complicated. Let's just deny the possibility for now
>> until this becomes a reality (let's hope it never does!).
> 
> Well, we can't do it this way. There are globally accessible clock
> event devices which deliver only to cpu0. So the mask check might be
> causing failure here.
> 
> Just add a feature flag CLOCK_EVT_FEAT_PERCPU to the clock event
> device and check for it.

It sounds probably more understandable than dealing with the cpumasks.

I am wondering if this is semantically opposed to
http://lwn.net/Articles/566270/ ?

[PATCH V3 0/6] cpuidle/ppc: Enable broadcast support for deep idle states

  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

  * English - detected
  * English
  * French

  * English
  * French

 <javascript:void(0);>
