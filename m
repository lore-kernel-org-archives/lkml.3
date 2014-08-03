Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaHCWRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 18:17:17 -0400
Received: from gloria.sntech.de ([95.129.55.99]:51649 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbaHCWRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 18:17:16 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@kernel.org>, linus.walleij@linaro.org
Cc: addy.ke@rock-chips.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: io-domain voltages as regulators?
Date: Mon, 04 Aug 2014 00:18:40 +0200
Message-ID: <3923586.SsVg941346@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, Linus,

I'd like to clarify what the appropriate way to handle pin output voltages is. 
On the Rockchip SoCs the voltage for some groups of pins can be set between 
3.3V and 1.8V ... like the MMC/SD pins who need this to support UHS mode 
cards.

In [0] when talking about something different, Linus Walleij described a 
similar case as

"I think we need to have a discussion with Mark Brown on how to
handle this.
We have previously had the case of MMC/SD level-shifters, where
a certain setting gives a certain level of signals out, and another setting
gives another level. Like two discrete levels.
So we modeled that as a regulator provider inside the pin control
driver eventually, see sh-pfc/pfc-sh73a0.c"

As this sound like exactly the thing I'm trying to solve, is handling this via 
a regulator the correct general way?


Thanks
Heiko

[0] https://lkml.org/lkml/2014/5/28/147
