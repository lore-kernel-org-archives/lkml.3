Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3BBCQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 21:16:45 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:51149 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab3BBCQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 21:16:43 -0500
Message-ID: <510C7708.4080707@kernel.org>
Date: Fri, 01 Feb 2013 21:16:40 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] intel_idle: stop using driver_data for static flags
References: <1359691896-23567-1-git-send-email-lenb@kernel.org> <9a38405338d7464c852c4524465f84f8a2ac22fb.1359691799.git.len.brown@intel.com> <510B8059.5040609@linaro.org> <510C0C22.4000801@kernel.org> <510C3EC5.3060709@linaro.org>
In-Reply-To: <510C3EC5.3060709@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> intel_idle already uses a driver-specific flag:
>>
>> #define CPUIDLE_FLAG_TLB_FLUSHED        0x10000
>>
>> This patch just uses 4 more bits along with that one.
> 
> Ok. In this case it would make sense to move this flag out of the
> generic core code to the intel_idle.c file ?

This flag is already local to intel_idle.c.
If another architecture finds it useful,
then yes, it would make sense to move it to the shared header.

> and move the [dec/en]coding
> macro flags_2_MWAIT_EAX and MWAIT_EAX_2_flags (with a more appropriate
> name for a generic code) to the cpuidle.h file ?

I think that a driver's private flag definitions
should remain local to the driver.  It makes no sense
to pollute the name space of other drivers for stuff
that doesn't mean anything to them.  MWAIT is pretty
specific to x86 -- and re-naming it to something 'generic'
isn't going to make the code easier to read.

thanks,
Len Brown, Intel Open Source Technology Center


