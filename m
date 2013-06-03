Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818Ab3FCHYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:24:20 -0400
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:49079 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999Ab3FCHYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:24:12 -0400
Message-ID: <51AC446D.5070503@st.com>
Date: Mon, 03 Jun 2013 08:23:25 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC] clocksource: Add clocksource drivers menu.
References: <1369994378-28163-1-git-send-email-srinivas.kandagatla@st.com> <51A8EE85.9030405@linaro.org>
In-Reply-To: <51A8EE85.9030405@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/13 19:40, John Stultz wrote:
> 
> And only just now did I notice that there are user-prompts in the
> drivers/clocksource/Kconfig.
> 
> I suspect the platform support options can safely select the proper
> clocksource config options without requiring the user to configure it.
> For the most part this is the case, even so folks still introduced some
> unnecessary clocksource config options (unnecessary as they don't prompt
> the user, default to y and depend on another config).
> 
> It looks like only: CLKSRC_DBX500_PRCMU &
> CLKSRC_DBX500_PRCMU_SCHED_CLOCK prompt the user right now.
> 
> Can you explain why its necessary the user has to be prompted here?

The only reason is to do with "how we present *SCHED_CLOCK options"?

If we make the *SCHED_CLOCK options default without prompts, then we do
not need a menu. These options can be selected at platform level
Kconfigs. We could possible cleanup the existing prompts.

Or

Make *SCHED_CLOCK option as a prompt then we do need a menu as these
prompts appear randomly in the menuconfig.

Am happy with either approach.

Thanks,
srini

> 
> I know the situation isn't your fault, and you're just trying to clean
> things up here. However I'd much prefer removing the user-prompt and
> trying to remove unnecessary configs over creating a new config menu.
> And if there must be a user-selected config, I'd much rather it be a
> platform config option rather then some generic-seeming driver config.
> 
> thanks
> -john

