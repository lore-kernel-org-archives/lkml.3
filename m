Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072AbaKXWq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:46:26 -0500
Received: from gloria.sntech.de ([95.129.55.99]:57988 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaKXWqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:46:25 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, mturquette@linaro.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Tony Xie <xxx@rock-chips.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 0/4] This is the 1st version of suspend for RK3288.
Date: Mon, 24 Nov 2014 23:50 +0100
Message-ID: <2829328.asIzdRTr9b@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416051910-16730-1-git-send-email-zyw@rock-chips.com>
References: <1416051910-16730-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Am Samstag, 15. November 2014, 19:45:06 schrieb Chris Zhong:
> This suspend patch is only support cut off the power of cpu and some
> external devices, since we still lack power_domain driver, so the other
> power rail of rk3288 need keep power on.
> I have tested it on rk3288-evb board, atop next-20141112. goto suspend by
> type "echo mem > /sys/power/state", vdd_cpu is about 0mv by measuring, so
> it can be determined in sleep mode, then press power button to wakeup it.

with this version my board can finally wake up again. Although it wakes 
immediatly again. But as it wakes at all, I'm quite happy :-) .

I remember this being mentioned before, but I don't remember what was 
responsible for that. Was it because we only enter the light suspend mode 
instead of the deep one or some interrupt somewhere?


I've been running on top of linux-next from 20141124 with the following 
patches applied on top of your v8 series:

pinctrl: rockchip: Fix enable/disable/mask/unmask
pinctrl: rockchip: Handle wakeup pins
serial: 8250_dw: Handle no_console_suspend when uart loses state


Heiko

