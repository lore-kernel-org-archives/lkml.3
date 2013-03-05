Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3CEGSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:18:13 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64653 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3CEGSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:18:08 -0500
Message-ID: <51358E17.8000106@linaro.org>
Date: Tue, 05 Mar 2013 14:17:59 +0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [RFC PATCH v2 0/4] Add support for S3 non-stop TSC support.
References: <1362450426-4232-1-git-send-email-feng.tang@intel.com> <20130305035302.GA5239@feng-snb> <20130305043203.GA26678@obsidianresearch.com>
In-Reply-To: <20130305043203.GA26678@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 12:32 PM, Jason Gunthorpe wrote:
> On Tue, Mar 05, 2013 at 11:53:02AM +0800, Feng Tang wrote:
>
>>> // Drops some small precision along the way but is simple..
>>> static inline u64 cyclecounter_cyc2ns_128(const struct cyclecounter *cc,
>>>                                            cycle_t cycles)
>>> {
>>>      u64 max = U64_MAX/cc->mult;
>>>      u64 num = cycles/max;
>>>      u64 result = num * ((max * cc->mult) >> cc->shift);
>>>      return result + cyclecounter_cyc2ns(cc, cycles - num*cc->mult);
>>> }
>> Your way is surely more accurate, if maintainers are ok with adding
>> the new API, I will use it.
> Okay, give it a good look though, I only wrote it out in email, never
> tested it :)
>
Probably want to use clocksource instead of cyclecounter, but I think 
Jason's approach sounds ok. I might suggest that you initially make the 
function static to the timekeeping code, just so we don't get unexpected 
users.

thanks
-john
