Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab3GRKkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:40:45 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:54997 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629Ab3GRKgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130718095035.GA29153@e106331-lin.cambridge.arm.com>
References: <1372943292-6960-1-git-send-email-jonas.jensen@gmail.com>
	<1374067396-30155-1-git-send-email-jonas.jensen@gmail.com>
	<20130718095035.GA29153@e106331-lin.cambridge.arm.com>
Date: Thu, 18 Jul 2013 12:36:40 +0200
Message-ID: <CACmBeS2SnpiUtiQD6j9qyaXZ5-chHSHVeo4c5=UhitVonvkKtw@mail.gmail.com>
Subject: Re: [PATCH v3] clk: add MOXA ART SoCs clock driver
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, thanks for taking a look at this.

On 18 July 2013 11:50, Mark Rutland <mark.rutland@arm.com> wrote:
> This confuses me. moxart_of_clk_init gets called because there was a
> "moxa,moxart-core-clock", node in the dt, but the driver only seems to
> use the information to figure out the configuration of another clock
> ("moxa,moxart-apb-clock"), and never registers a clock specifically for
> the core-clock.
>
> I couldn't find "moxa,moxart-apb-clock" described in mainline. COuld you
> describe the relationship between core-clock and apb-clock?

It's true core-clock exist only so the register can be mapped.

apb-clock is part of a patch set that will add new device tree files for the
MOXA ART SoC, but it's not in mainline:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181757.html

apb-clock could be a fixed rate 48MHz DT only clock, but because we can't
be sure it's 48MHz on all platforms, reading it from a register with core-clock
is more portable.


Best regards,
Jonas
