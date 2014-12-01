Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbaLAXFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:05:03 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:58817 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbaLAXFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:05:00 -0500
MIME-Version: 1.0
In-Reply-To: <20141201225057.GA11285@n2100.arm.linux.org.uk>
References: <1417461694-5129-1-git-send-email-dianders@chromium.org>
	<20141201225057.GA11285@n2100.arm.linux.org.uk>
Date: Mon, 1 Dec 2014 15:04:59 -0800
X-Google-Sender-Auth: pq2_z3Plzafnib0N9jqPV6tnRKk
Message-ID: <CAD=FV=VT7gr504-ZgWPfha+40XDX5eShkzZ36bg=-4Oub1S27w@mail.gmail.com>
Subject: Re: [PATCH] ARM: rockchip: Convert resume code to C
From: Doug Anderson <dianders@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Heiko Stuebner <heiko@sntech.de>, Chris Zhong <zyw@rock-chips.com>,
        Kevin Hilman <khilman@linaro.org>, Sonny Rao <sonnyrao@chromium.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        russ.dill@gmail.com, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russel,

On Mon, Dec 1, 2014 at 2:50 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> What I see here is a load of complexity which achieves very little.
> The result doesn't get rid of much assembly, but it does make stuff
> more complicated.  And the diffstat speaks volumes about this:
>
>  10 files changed, 275 insertions(+), 94 deletions(-)
>
> There's a lot of words in the description, but it's missing the most
> important bit: why do we want to take this approach - what benefits
> does it bring?

Sure.  I guess the most important words in the description are:

> We convert the existing assembly resume code into C as proof that this
> works and to prepare for linking in SDRAM reinit code.

I can't say that the SDRAM reinit code is ready for prime time yet,
but you can get a preview of what it could look like at:

https://chromium-review.googlesource.com/#/c/227366/25/arch/arm/mach-rockchip/embedded/rk3288_ddr_resume.c

Adding that code in assembly seems like a very, very bad idea.
Certainly my patch could wait until the DDR code is ready to be posted
upstream if that made sense.  One advantage of waiting is that it's
possible that the DDR code might end up moving elsewhere if it made
sense to have it part of a memory controller driver or something like
that.

-Doug
