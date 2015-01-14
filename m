Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbbANWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:16:26 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:50095 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbbANWQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:16:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "Kever Yang" <kever.yang@rock-chips.com>, dianders@chromium.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <3353483.Eif0pChkY5@phil>
Cc: sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org, tomeu.vizoso@collabora.com,
        sboyd@codeaurora.org, "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, "Dmitry Torokhov" <dtor@chromium.org>,
        linux-kernel@vger.kernel.org, "Kumar Gala" <galak@codeaurora.org>,
        "Jianqun" <jay.xu@rock-chips.com>, "Rob Herring" <robh+dt@kernel.org>,
        "Pawel Moll" <pawel.moll@arm.com>, "Chris Zhong" <zyw@rock-chips.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
References: <1416236138-11010-1-git-send-email-kever.yang@rock-chips.com>
 <3353483.Eif0pChkY5@phil>
Message-ID: <20150114221615.22722.24878@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC PATCH 0/2] clk: rockchip: leave npll for DCLK_VOP0(HDMI) only
Date: Wed, 14 Jan 2015 14:16:15 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Heiko Stübner (2015-01-08 14:30:01)
> Hi Kever,
> 
> Am Montag, 17. November 2014, 22:55:36 schrieb Kever Yang:
> > To support all kinds of frequency requirement for HDMI on rk3288,
> > we need a PLL that can change rate at run time.
> > 
> > There are some discussion before at [0], I think we can just leave
> > the npll for HDMI(DCLK_VOP0) used to make it simple.
> > 
> > Comments are welcome.
> 
> I think I said it in private somewhere already, but just so it's also 
> available publically:
> 
> I don't think customizing/limiting the clock usage like this will fly, 
> especially as this would require each and every rk3288 board to use vop0 for 
> hdmi and vop1 for other stuff.
> 
> With the new rk3288 Firefly devboard this concern already becomes reality. 
> There a vga converter is connected to VOP0, which leaves only vop1 for hdmi if 
> one wants to support the vga connection.
> 
> 
> From our discussion about this problem I remember that the missing clock 
> frequencies only affected more esotheric screen resolutions, so personally I'm 
> not this much concerned an would like to wait till we find a better solution to 
> the problem.

Ack. We shouldn't have to limit the possible hardware configurations in
software just to keep things simple. This points to a deficiency in the
clock framework. This is a common concern: how to change a clock
frequency for one user without exploding all of the other users.

Do you think Tomeu's constraints API[0] might be a step in the right
direction for you?

[0] http://lkml.kernel.org/r/<1421071809-17402-3-git-send-email-tomeu.vizoso@collabora.com>

Regards,
Mike

> 
> 
> Heiko
