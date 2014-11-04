Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaKDVzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:55:38 -0500
Received: from gloria.sntech.de ([95.129.55.99]:50246 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbaKDVzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:55:35 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        xjq@rock-chips.com, hj@rock-chips.com, dkl@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] clk: rockchip: disable unused clocks
Date: Tue, 04 Nov 2014 22:58:45 +0100
Message-ID: <14899684.S24jkIkXzQ@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1415092270-24932-1-git-send-email-kever.yang@rock-chips.com>
References: <1415092270-24932-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kever,

Am Dienstag, 4. November 2014, 17:11:10 schrieb Kever Yang:
> The rockchip clock driver use CLK_IGNORE_UNUSED flag to make sure
> all the clocks are available like default power on state.
> We have implement the clock manage in most of rockchip drivers,
> it is time to remove it for power save.
> Instead we add CLK_IGNORE_UNUSED for some clock nodes which should
> be on during boot or no module driver in kernel will initialize it.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>

I applied this with some slight modifications.
- it seemed to be based on your dclk_ops series - fixed that
- remove the flag from the uart2 on the cortex-a9 too
- let DCLK_VOPx and HCLK_VOPx be autodisabled on rk3288
  [tested by Doug]


Heiko
