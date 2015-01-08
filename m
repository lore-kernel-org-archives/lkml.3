Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbbAHWaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:30:25 -0500
Received: from gloria.sntech.de ([95.129.55.99]:37507 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616AbbAHWaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:30:22 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>, dianders@chromium.org
Cc: Mike Turquette <mturquette@linaro.org>, sonnyrao@chromium.org,
        addy.ke@rock-chips.com, cf@rock-chips.com, dkl@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        tomeu.vizoso@collabora.com, sboyd@codeaurora.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Dmitry Torokhov <dtor@chromium.org>,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Jianqun <jay.xu@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Chris Zhong <zyw@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/2] clk: rockchip: leave npll for DCLK_VOP0(HDMI) only
Date: Thu, 08 Jan 2015 23:30:01 +0100
Message-ID: <3353483.Eif0pChkY5@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1416236138-11010-1-git-send-email-kever.yang@rock-chips.com>
References: <1416236138-11010-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kever,

Am Montag, 17. November 2014, 22:55:36 schrieb Kever Yang:
> To support all kinds of frequency requirement for HDMI on rk3288,
> we need a PLL that can change rate at run time.
> 
> There are some discussion before at [0], I think we can just leave
> the npll for HDMI(DCLK_VOP0) used to make it simple.
> 
> Comments are welcome.

I think I said it in private somewhere already, but just so it's also 
available publically:

I don't think customizing/limiting the clock usage like this will fly, 
especially as this would require each and every rk3288 board to use vop0 for 
hdmi and vop1 for other stuff.

With the new rk3288 Firefly devboard this concern already becomes reality. 
There a vga converter is connected to VOP0, which leaves only vop1 for hdmi if 
one wants to support the vga connection.


>From our discussion about this problem I remember that the missing clock 
frequencies only affected more esotheric screen resolutions, so personally I'm 
not this much concerned an would like to wait till we find a better solution to 
the problem.


Heiko
