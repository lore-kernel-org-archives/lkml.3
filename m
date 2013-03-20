Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab3CTQsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:48:43 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:41965 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3CTQsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:48:41 -0400
Message-ID: <5149E85E.90701@gmail.com>
Date: Wed, 20 Mar 2013 17:48:30 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: michal.bachraty@gmail.com
CC: fa.linux.kernel@googlegroups.com, Mike Turquette <mturquette@linaro.org>,
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
Subject: Re: [PATCH v3] clk: add si5351 i2c common clock driver
References: <fa.WZVD0OA/Ooajh6BejiLf7TwBsJ8@ifi.uio.no> <fa.iIqrS6k+Vb5mLqAeL7iTsNsbKyo@ifi.uio.no> <fa.L0b41q+fYFZG0WOFTGKLhn/cGPA@ifi.uio.no> <fa.XCuSmq9Zwp3+wqFO8NEjpwADVZ0@ifi.uio.no> <6e120226-8a3c-415f-90f2-c44e7b6bbf96@googlegroups.com>
In-Reply-To: <6e120226-8a3c-415f-90f2-c44e7b6bbf96@googlegroups.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 20.03.2013 14:55, michal.bachraty@gmail.com wrote:
> Thanks for writing this driver! I have tested your si5351 clock 
> driver and his tuning capabilities. It works well, it generates 
> proper clock frequency, but when new frequency is generated, little 
> clock gap (1ms) is generated. Si5351 datasheet and WP claims, clock 
> tuning can be without gaps - 
> http://www.silabs.com/Support%20Documents/TechnicalDocs/Si5350-51-Frequency-Shifting-WP.pdf
>
> I made some tests with Si5351A chip and I found that when tuning touch
> only Multisynth registers, it can tune without gaps. There is no need
> for soft PLL reset. I found also, accessing Multisynth registers is not
> atomic, so there can be another frequency at output, while not all
> registers are written. Writing only to one register seems to be atomic.

Yeah, but limiting possible changes to the PLLs to one single register
also means that you cannot offer to generate all the frequencies any
more. What could probably be done is refine the algorithm so that it
stays 'as close as possible' to the former values, but I'm not sure how
much work that implies.

Can you provide a patch against Sebastian's v3 to do that? Then it can
be cleanly applied on top of the driver later.


Daniel
