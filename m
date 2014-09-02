Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaIBTqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:46:24 -0400
Received: from gloria.sntech.de ([95.129.55.99]:54484 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbaIBTqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:46:22 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Mark Brown <broonie@kernel.org>, Chris Zhong <zyw@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, zhangqing@rock-chips.com,
        lgirdwood@gmail.com, robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        galak@codeaurora.org
Subject: Re: [PATCH 0/2] Add input supplies to rk808 regulator
Date: Tue, 02 Sep 2014 21:48:14 +0200
Message-ID: <13302580.b33ghgBegF@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1409674469-12123-1-git-send-email-dianders@chromium.org>
References: <1409674469-12123-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 2. September 2014, 09:14:27 schrieb Doug Anderson:
> We want to specify the input supplies to the rk808 regulator.  This
> patch series adds them to the driver.  Note that the bindings are
> based atop Chris's most recent version at
> <https://patchwork.kernel.org/patch/4817931/>.  If the regulator patch
> is applied before Chris sends out his next version then I think Chris
> could squash my bindings change (patch 2) into his next version.
> 
> 
> Doug Anderson (2):
>   regulator: RK808: Add proper input supplies for rk808

Patch 1 didn't apply, as it didn't take the recent pdata removal Chris
posted. After fixing this [0], it sucessfully solved the missing supplies
I've seen on the weekend, so

Tested-by: Heiko Stuebner <heiko@sntech.de>


>   dt-bindings: Add input supplies to rk808 bindings
> 
>  Documentation/devicetree/bindings/mfd/rk808.txt | 11 +++++++++++
>  drivers/regulator/rk808-regulator.c             | 15 ++++++++++++++-
>  2 files changed, 25 insertions(+), 1 deletion(-)



[0]
--- "[PATCH 1_2] regulator_RK808_Add proper input supplies for rk808.mbox.orig"	2014-09-02 20:49:12.000000000 +0200
+++ "[PATCH 1_2] regulator_RK808_Add proper input supplies for rk808.mbox"	2014-09-02 21:22:57.052197875 +0200
@@ -203,7 +203,7 @@
  		.type = REGULATOR_VOLTAGE,
 @@ -364,7 +378,6 @@ static int rk808_regulator_probe(struct platform_device *pdev)
  		if (client->dev.of_node)
- 			config.of_node = pdata->of_node[i];
+ 			config.of_node = rk808_regulator->of_node[i];
  
 -		reg_data->supply_regulator = rk808_reg[i].name;
  		config.init_data = reg_data;

As Chris is supposed to merge these changes into his series, this doesn't
really matter though.
