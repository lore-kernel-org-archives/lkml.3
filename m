Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab3EPERI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:17:08 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15278 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3EPERE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:17:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="47795823"
Message-ID: <51945DBF.60308@codeaurora.org>
Date: Wed, 15 May 2013 21:17:03 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH] clk: Fix race condition between clk_set_parent and clk_enable()
References: <1367383328-25700-1-git-send-email-skannan@codeaurora.org> <CAPDyKFpZ6-O-zSyBVgGGFL4W+d=-k-qaXimUS12fgC=9TkUNVA@mail.gmail.com>
In-Reply-To: <CAPDyKFpZ6-O-zSyBVgGGFL4W+d=-k-qaXimUS12fgC=9TkUNVA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 12:24 PM, Ulf Hansson wrote:
> On 1 May 2013 06:42, Saravana Kannan <skannan@codeaurora.org> wrote:

<snip>

>> -       /* migrate prepare */
>> -       if (clk->prepare_count)
>> +       /*
>> +        * Migrate prepare state between parents and prevent race with
>> +        * clk_enable().
>> +        *
>> +        * If the clock is not prepared, then a race with
>> +        * clk_enable/disable() is impossible since we already have the
>> +        * prepare lock (future calls to clk_enable() need to be preceded by
>> +        * a clk_prepare()).
>> +        *
>> +        * If the clock is prepared, migrate the prepared state to the new
>> +        * parent and also protect against a race with clk_enable() by
>> +        * forcing the clock and the new parent on.  This ensures that all
>> +        * future calls to clk_enable() are practically NOPs with respect to
>> +        * hardware and software states.
>> +        */
>
> Maybe an additional note about that since CLK_SET_PARENT_GATE is a
> prerequisite for doing migration of "prepare", we also interpreted
> this flags as it is acceptable to enable the clock(s) in this context.

Done. Sent v2 patch.

<snip>

>
> Looks good! Thanks for having another round to fixup this kind of
> tricky code. :-)

Thanks :-)

> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>

Thanks again.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
