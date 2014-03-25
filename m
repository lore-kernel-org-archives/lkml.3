Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaCYX4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:56:11 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50229 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbaCYX4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:56:10 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Beniamino Galvani <b.galvani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] pinctrl: rockchip: fix handling of first pinbank
Date: Wed, 26 Mar 2014 00:56:15 +0100
Message-ID: <1647754.qr1tAySXax@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140325194357.GA27520@gmail.com>
References: <1395700561-3793-1-git-send-email-b.galvani@gmail.com> <2790002.5U2DHYmUbK@diego> <20140325194357.GA27520@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. März 2014, 20:43:59 schrieb Beniamino Galvani:
> On Tue, Mar 25, 2014 at 12:14:42AM +0100, Heiko Stübner wrote:
> > GPIO0 only has the second two IOMUX registers:
> > - GRF_GPIO0C_IOMUX at 0x68
> > - GRF_GPIO0D_IOMUX at 0x6c
> > which I guess is where my mistake comes from.

[...] 

> On radxa rock schematic pins GPIO0A* and GPIO0B* are labeled only as
> gpios, without alternate functions like other pins; my guess is that
> on rk3188 they can only act as gpios and so mux registers are not
> needed for them.

That was my guess too - especially as the registers are also missing.

Therefore I put together the following two patches to go on top of
your patch and also make rockchip_set_mux honor this situation.


Heiko Stuebner (2):
  pinctrl: rockchip: add return value to rockchip_set_mux
  pinctrl: rockchip: handle first half of rk3188-bank0 correctly

 drivers/pinctrl/pinctrl-rockchip.c | 46 ++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 7 deletions(-)

-- 
1.9.0


