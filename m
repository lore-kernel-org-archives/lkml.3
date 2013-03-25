Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab3CYLyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:54:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50307 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab3CYLyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:54:18 -0400
MIME-Version: 1.0
In-Reply-To: <5149E85E.90701@gmail.com>
References: <fa.WZVD0OA/Ooajh6BejiLf7TwBsJ8@ifi.uio.no>
	<fa.iIqrS6k+Vb5mLqAeL7iTsNsbKyo@ifi.uio.no>
	<fa.L0b41q+fYFZG0WOFTGKLhn/cGPA@ifi.uio.no>
	<fa.XCuSmq9Zwp3+wqFO8NEjpwADVZ0@ifi.uio.no>
	<6e120226-8a3c-415f-90f2-c44e7b6bbf96@googlegroups.com>
	<5149E85E.90701@gmail.com>
Date: Mon, 25 Mar 2013 12:54:17 +0100
Message-ID: <CABJ1b_T2x-DkTuYZGLBiedFRWcgYbcN3VCorN2nm3Y54A--wyw@mail.gmail.com>
Subject: Re: [PATCH v3] clk: add si5351 i2c common clock driver
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: michal.bachraty@gmail.com, fa.linux.kernel@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 5:48 PM, Daniel Mack <zonque@gmail.com> wrote:
> On 20.03.2013 14:55, michal.bachraty@gmail.com wrote:
>> Thanks for writing this driver! I have tested your si5351 clock
>> driver and his tuning capabilities. It works well, it generates
>> proper clock frequency, but when new frequency is generated, little
>> clock gap (1ms) is generated. Si5351 datasheet and WP claims, clock
>> tuning can be without gaps -
>> http://www.silabs.com/Support%20Documents/TechnicalDocs/Si5350-51-Frequency-Shifting-WP.pdf
>>
>> I made some tests with Si5351A chip and I found that when tuning touch
>> only Multisynth registers, it can tune without gaps. There is no need
>> for soft PLL reset. I found also, accessing Multisynth registers is not
>> atomic, so there can be another frequency at output, while not all
>> registers are written. Writing only to one register seems to be atomic.

Michael,

if you don't configure the clock output to modify the pll, changing output
frequency will not alter pll config and there will be no reset of pll.

> Yeah, but limiting possible changes to the PLLs to one single register
> also means that you cannot offer to generate all the frequencies any
> more. What could probably be done is refine the algorithm so that it
> stays 'as close as possible' to the former values, but I'm not sure how
> much work that implies.
>
> Can you provide a patch against Sebastian's v3 to do that? Then it can
> be cleanly applied on top of the driver later.

Ack. Feel free to post a patch on top of v4 now.

Sebastian
