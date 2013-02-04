Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3BDVVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:21:38 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:48893 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3BDVVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:21:37 -0500
MIME-Version: 1.0
In-Reply-To: <20130204193737.GU4720@opensource.wolfsonmicro.com>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
	<1359978868-28736-6-git-send-email-lee.jones@linaro.org>
	<20130204193737.GU4720@opensource.wolfsonmicro.com>
Date: Mon, 4 Feb 2013 22:21:36 +0100
Message-ID: <CACRpkdYWZOa=bbJYpG7owxVJXxPq5sx7jHmo5UpRe8pmPGYKMQ@mail.gmail.com>
Subject: Re: [PATCH 05/73] ARM: ux500: Vsmps3 controlled by SysClkReq1
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 8:37 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Feb 04, 2013 at 11:53:20AM +0000, Lee Jones wrote:
>> Vsmps3 is put in HW control by SysClkReq1 at init. The
>> corresponding settings in suspend-force are removed.
>
> So, I've applied the patches up to here though I'm still reallly unhappy
> with this code - it seems clear from the comments that a lot of this
> stuff should be using regulator constraints to initialise.  It would be
> good to move this stuff over to use the framework.

So I've briefly discussed it with Bengt at one point.

Basically what the ABx500 PMICs have is a sort of
logic network or table that you can set up to respond
autonomously to different "SysClkReq" signals.

Originally these signals were intended for gating
and ungating clocks but they are basically a boolean
"enable that resource I want" signals.

So it is not even primarily used for clocks, but
regulators. It will for example power them off/on
on that signal but also more elaborate stuff I think.

What is needed is some way to model that
electronic relationship into both the regulator
and clock subsystems (Ulf Hansson is working on
the ABx500 clocks as we speak.)

Maybe the actual place to have it would be
somewhere like drivers/mfd/ab8500-core.c.

Have you seen similar stuff in other PMICs?

Yours,
Linus Walleij
