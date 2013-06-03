Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610Ab3FCSTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:19:36 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51128 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab3FCSTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:19:34 -0400
Message-ID: <51ACDE33.6060000@linaro.org>
Date: Mon, 03 Jun 2013 11:19:31 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: srinivas.kandagatla@st.com
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC] clocksource: Add clocksource drivers menu.
References: <1369994378-28163-1-git-send-email-srinivas.kandagatla@st.com> <51A8EE85.9030405@linaro.org> <51AC446D.5070503@st.com>
In-Reply-To: <51AC446D.5070503@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 12:23 AM, Srinivas KANDAGATLA wrote:
> On 31/05/13 19:40, John Stultz wrote:
>> And only just now did I notice that there are user-prompts in the
>> drivers/clocksource/Kconfig.
>>
>> I suspect the platform support options can safely select the proper
>> clocksource config options without requiring the user to configure it.
>> For the most part this is the case, even so folks still introduced some
>> unnecessary clocksource config options (unnecessary as they don't prompt
>> the user, default to y and depend on another config).
>>
>> It looks like only: CLKSRC_DBX500_PRCMU &
>> CLKSRC_DBX500_PRCMU_SCHED_CLOCK prompt the user right now.
>>
>> Can you explain why its necessary the user has to be prompted here?
> The only reason is to do with "how we present *SCHED_CLOCK options"?
>
> If we make the *SCHED_CLOCK options default without prompts, then we do
> not need a menu. These options can be selected at platform level
> Kconfigs. We could possible cleanup the existing prompts.

Right. This is what I'm asking for. Since there are only two options 
that prompt the user, I'm asking if there is a reason the user needs to 
be prompted.

I not, we can just remove the prompts and simplify the config.

If there is a valid reason to prompt the user, then we may need to add a 
menu, but I'd probably prefer we add the option in the platform menu, 
rather then generate a new driver menu.

thanks
-john

