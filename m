Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaKFVD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:03:29 -0500
Received: from gloria.sntech.de ([95.129.55.99]:49029 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaKFVD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:03:26 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        fzf@rock-chips.com, ykk@rock-chips.com, yzq@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] clk: rockchip: add full support for HDMI clock on rk3288
Date: Thu, 06 Nov 2014 22:06:45 +0100
Message-ID: <48806799.thBSifdUp8@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
References: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kever,

Am Dienstag, 4. November 2014, 15:52:34 schrieb Kever Yang:
> we are going to make a clock usage solution for rk3288:
> 1. CPLL and GPLL always not change after assign init;
> 2. NPLL default as 500MHz, may used for most scene;
> 3. NPLL may be changed by VOP(HDMI) clock for some special
>    frequency requirement.
> 
>     I test it with rk3288 evb on top of Heiko's clk-for-next

In general I'm not really sure if allowing one component to arbitarily change 
a shared clock wouldn't result in trouble.

At the moment only dclk_vop0 is included in your series, while the hdmi 
controller can connect to both vop0 and vop1.
And as Doug mentioned the gpu also has the npll as one possible source.

Looking through the clock-tree there are a lot more components possibly using 
(or wanting to use) the npll: of course the VOPs, the edp, hdmi, isp, hevc, 
gpu, tsp uart0 and gmac. So I'm slightly uncomfortable with somehow reserving 
the npll for VOP0 alone.

But I also don't see a different way to get these frequencies right now.


Heiko
