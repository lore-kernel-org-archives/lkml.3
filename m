Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaIIMGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:06:13 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:63339 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbaIIMGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:06:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org, srinivas.kandagatla@gmail.com,
        linux-kernel@vger.kernel.org, patrice.chotard@st.com,
        Peter Griffin <peter.griffin@linaro.org>, peppe.cavallaro@st.com,
        kishon@ti.com, lee.jones@linaro.org, maxime.coquelin@st.com
Subject: Re: [PATCH v2 1/4] phy: phy-stih407-usb: Add usb picoPHY driver found on stih407 SoC family
Date: Tue, 09 Sep 2014 14:05:51 +0200
Message-ID: <2931258.khlMVogpQg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1706244.K6iQdujHby@amdc1032>
References: <1410253218-18318-1-git-send-email-peter.griffin@linaro.org> <1410253218-18318-2-git-send-email-peter.griffin@linaro.org> <1706244.K6iQdujHby@amdc1032>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6EcUHxjwCBWXJLiXtQIuR+1LhR0nBNz/+N6Z4kUNcY6
 K+BlgSCeF7Ws9Ql6yNq+gUxv4mjxtM0K3h3CPCVX4/s9lHI88k
 hl4Oyveq+GHp8yuZFkFhEEATBenv0WYwKqWoSx5ia+m3HmsSgB
 UhGA7S+FhZDMq/m8QW3FUy/RWWrBW+oVqzElRL/Iw8SZFKriqN
 2tfjC+Jl8/vJ8MuAylwbzqDVWkvhZ7REAurEbTcVlA96Cd35vU
 AxB0RzcjhruqjldQ5SeiFfguCCU4BYm2eP9FPWzICrA8xjauTE
 QqAo7oJvNyr1t1Vn+RN9ScvpQFyJWEp3dJGmwyTG0tkXe7Pq8G
 BRkBzg/GwT+qr8uUa6Yg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 13:52:54 Bartlomiej Zolnierkiewicz wrote:
> I believe that this should use
> 
>         select GENERIC_PHY
> 
> instead (just like all other PHY drivers except PHY_MIPHY365X which
> also should be fixed to use select).

Right. It would also be good to change 'depends on ARCH_STI'
into 'depends on ARCH_STI || COMPILE_TEST', but only if it
actually compiles on x86.

Note that currently both providers and users of the PHY API
use 'select GENERIC_PHY', which probably not what we want:
only providers (like this one) should 'select' it, while
drivers using this interface could either 'depends on
GENERIC_PHY' or leave out the Kconfig dependency entirely.

Adding 'depends on' for drivers using the interface might
be cleaner, but can result in dependency loops.

	Arnd
