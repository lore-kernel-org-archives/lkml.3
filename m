Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab3BBUS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 15:18:28 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:61711 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab3BBUSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 15:18:25 -0500
Message-ID: <510D748E.4010605@kernel.org>
Date: Sat, 02 Feb 2013 15:18:22 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH 1/4] intel_idle: stop using driver_data for static flags
References: <1359691896-23567-1-git-send-email-lenb@kernel.org> <9a38405338d7464c852c4524465f84f8a2ac22fb.1359691799.git.len.brown@intel.com> <510B8059.5040609@linaro.org> <510C0C22.4000801@kernel.org> <510C3EC5.3060709@linaro.org> <510C7708.4080707@kernel.org> <510CDFF1.80408@linaro.org>
In-Reply-To: <510CDFF1.80408@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I think that a driver's private flag definitions
>> should remain local to the driver.  It makes no sense
>> to pollute the name space of other drivers for stuff
>> that doesn't mean anything to them.  MWAIT is pretty
>> specific to x86 -- and re-naming it to something 'generic'
>> isn't going to make the code easier to read.
> 
> Ok, let me rephrase it because I think how it was presented was not clear.
> 
> As we want to use the half of the state flags for private purpose, I
> suggested to add the encoding/decoding function in the shared header file.
> 
> The mwait eax flags are not encoded and the CPUIDLE_FLAG_TLB_FLUSHED is
> encoded.
> 
> I suggested to unify both and to use an encoding function from the
> shared header file.
> 
> #define CPUIDLE_PRIVATE_FLAGS(_flags_) \
> 	((_flags_) << 16) & CPUIDLE_DRIVER_FLAGS_MASK
> 
> For example:
> 
> #define FLAG_TLB_FLUSHED CPUIDLE_PRIVATE_FLAGS(0x1)
> #define FLAG_MWAIT_C1    CPUIDLE_PRIVATE_FLAGS(0x0)
> #define FLAG_MWAIT_C2    CPUIDLE_PRIVATE_FLAGS(0x10)
> #define FLAG_MWAIT_C3    CPUIDLE_PRIVATE_FLAGS(0x20)
> #define FLAG_MWAIT_C4    CPUIDLE_PRIVATE_FLAGS(0x30)
> #define FLAG_MWAIT_C5    CPUIDLE_PRIVATE_FLAGS(0x40)
> #define FLAG_MWAIT_C6    CPUIDLE_PRIVATE_FLAGS(0x52)
> 
> And then:
> 
> ...
> 
> .flags = FLAG_TLB_FLUSHED | FLAG_MWAIT_C2 | CPUIDLE_FLAG_TIME_VALID

I like your syntax better than what I used -- thanks for suggesting it.

I can't use it as-is, however, because I really do need to be able to
support unique parameters on each entry (eg. different flags for C3
on different processors).  When some of the logical and functional
changes in flux settle out I'll come back to re-visit the syntax.

thanks,
-Len Brown, Intel Open Source Technology Center

