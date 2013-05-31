Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3EaSkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 14:40:19 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:32793 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab3EaSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 14:40:08 -0400
Message-ID: <51A8EE85.9030405@linaro.org>
Date: Fri, 31 May 2013 11:40:05 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC] clocksource: Add clocksource drivers menu.
References: <1369994378-28163-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1369994378-28163-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 02:59 AM, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> This patch adds "Clocksource drivers" menu to clocksource drivers.
> The reason to add this is because, some of the clocksource Kconfig
> options like *SHED_CLK ones are selectable and they appear at random
> places in the device drivers menu.
> These options can be more than one option for multiplatform case, so I
> think it will be neat to get a menu to clocksource drivers itself.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Sigh. So I've done a poor job at being a maintainer[1], and sort of left 
the barn door open here.

I'd *really* like to avoid having a clocksource config menu. Looking at 
the existing RTC menu as an example, there's just a ton of random 
hardware names that the user has to try to figure out if it applies to 
their system or not. For instance, on x86 I have to filter through 90% 
of the RTC drivers that aren't ever even an option on any x86 hardware.

It just turns into a needless config headache.

And only just now did I notice that there are user-prompts in the 
drivers/clocksource/Kconfig.

I suspect the platform support options can safely select the proper 
clocksource config options without requiring the user to configure it. 
For the most part this is the case, even so folks still introduced some 
unnecessary clocksource config options (unnecessary as they don't prompt 
the user, default to y and depend on another config).

It looks like only: CLKSRC_DBX500_PRCMU & 
CLKSRC_DBX500_PRCMU_SCHED_CLOCK prompt the user right now.

Can you explain why its necessary the user has to be prompted here?

I know the situation isn't your fault, and you're just trying to clean 
things up here. However I'd much prefer removing the user-prompt and 
trying to remove unnecessary configs over creating a new config menu. 
And if there must be a user-selected config, I'd much rather it be a 
platform config option rather then some generic-seeming driver config.

thanks
-john

[1] I'm no good at flames. Linus does a much better job covering this topic:
     http://lkml.indiana.edu/hypermail/linux/kernel/1304.3/02435.html
