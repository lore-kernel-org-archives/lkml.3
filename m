Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaLUOEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 09:04:48 -0500
Received: from gloria.sntech.de ([95.129.55.99]:43701 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbaLUOEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 09:04:47 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-rockchip@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Bump SD card pin drive strength up on rk3288-evb
Date: Sun, 21 Dec 2014 15:04:13 +0100
Message-ID: <2971473.Y1akaDeraL@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1418244929-8254-1-git-send-email-dianders@chromium.org>
References: <1418244929-8254-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 10. Dezember 2014, 12:55:29 schrieb Doug Anderson:
> It seems that ever since (536f6b9 mmc: dw_mmc: Reset DMA before
> enabling IDMAC) landed upstream that SD cards have been very unhappy
> on rk3288-evb.  They were a little unhappy before that change, but
> after that change they're REALLY unhappy.
> 
> It turns out that the above fix happens to fix a corruption when
> reading card information during probe time.  Without the fix we didn't
> detect that high speed SD cards could actually support high speed.
> With the fix we suddenly detect that they're high speed and we try to
> use them at 50MHz.  That doesn't work so well on EVB with the default
> drive strength (maybe because there are two physical SD card slots
> hooked up to the same pin?).
> 
> Fix the problem by bumping up the drive strength of the sdmmc lines.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Fixes: 536f6b91d21b ("mmc: dw_mmc: Reset DMA before enabling IDMAC")

applied to my 3.19 dts-fixes branch
(after a slight modification of the subject: please use "ARM: dts: rockchip:")


Heiko
