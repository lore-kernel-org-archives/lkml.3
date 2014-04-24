Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbaDXN00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:26:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38269 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753360AbaDXN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:26:24 -0400
Date: Thu, 24 Apr 2014 15:26:20 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] ARM: berlin: add pinctrl support
Message-ID: <20140424152620.39eae472@skate>
In-Reply-To: <CACRpkdbT94HqVroM_0gSJJ8Q2+YaKXLwjFGMn+4SCa_PYiF19Q@mail.gmail.com>
References: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com>
	<CACRpkdbT94HqVroM_0gSJJ8Q2+YaKXLwjFGMn+4SCa_PYiF19Q@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus Walleij,

On Thu, 24 Apr 2014 14:52:20 +0200, Linus Walleij wrote:

> > Tested on the Berlin BG2Q.
> 
> So now I need some advice from the mvebu pinctrl maintainers
> (Thomas, Sebastian etc):
> 
> - Is this a totally different pin controller so that drivers/pinctrl/mvebu
>  can not be used?

It is. The CPU families are completely different, made from completely
separate divisions of Marvell. Just think that they come from different
companies :-)

On the mvebu side, each pin can be independently configured to a
different function: there is a 4-bits field for each pin to configure
the function.

On the berlin side, pins are only configured in groups. You can't
independently set the functions of each pin: you can set a function to
a pre-defined set of pins.

> - Really?

Yes.

> - OK can you help me review this thing?

Sure. I believe Sebastian already had a very detailed look so he can
provide his review.

> - Should the base folder really be named "berlin" or is this going to
>   be part of a bigger family of pin controllers so a more neutral name
>   should be sought?

berlin is the name of the mach-<foo> directory in arch/arm, and that's
really the code name for this SoC family.

> - Why do hardware engineers seek to reinvent wheels like pin
>   controllers, GPIO and DMA engines all the time :-/

I guess Russell already gave you a good answer to this question :-)

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
