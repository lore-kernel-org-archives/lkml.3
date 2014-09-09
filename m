Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaIIJIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:08:54 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:52929 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbaIIJIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:08:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Griffin <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org,
        kishon@ti.com, srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/4] phy: phy-stih407-usb: Add usb picoPHY driver found on stih407 SoC family
Date: Tue, 09 Sep 2014 11:08:11 +0200
Message-ID: <2894228.eRmxgHsWbh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410253218-18318-2-git-send-email-peter.griffin@linaro.org>
References: <1410253218-18318-1-git-send-email-peter.griffin@linaro.org> <1410253218-18318-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:A3zynyeGSAeSqL0ms/n7XS8RQicjE+hUWgHVl/xl24G
 cWtQHdOG0v+WCPniAzwNrGT7Bompsajbv4scBk/TPd8zBWVcC2
 P7MH12FNLJsIQLitaITKvXNuJePuDaR+Et86UzdtPE0LDek7OX
 MzFqnU4/tGAGAKxiMq1UZ8u7kGZJEcG+RChOHkqltMdxGfnwr1
 qajmriEK0kfFkfA1c5nrMfv5/ME8U7n2I2j03Zf3z3eaMljgRM
 NoQxO0WZNVYk6iTxCSIs6TYH0HBRtv4Ib2mM61X892HS3Y2b13
 FoG4gpk0WNjqvtAWSXQO/hJa52C+qnj3Km2H3gvQxSrDnMTUj5
 H3cO/Wulv/i6KqGbhF/U=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 10:00:15 Peter Griffin wrote:
> This is the generic phy driver for the picoPHY ports used by the
> USB2 and USB3 Host controllers when controlling usb2/1.1 devices. It
> is found on STiH407 SoC family from STMicroelectronics.
> 
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Looks good overall, just one question:

> +
> +	match = of_match_device(stih407_usb2_picophy_of_match, dev);
> +	if (!match)
> +		return -ENODEV;
....
> +
> +	phy = devm_phy_create(dev, NULL, match->data, NULL);
> +	if (IS_ERR(phy)) {
> +		dev_err(dev, "failed to create Display Port PHY\n");
> +		return PTR_ERR(phy);
> +	}
> +

There is only one entry in the match table, so it always points to
stih407_usb2_picophy_data. Do you have plans to add another set of
operations soon?
If not, just remove the .data pointer and hardcode the operations
in the devm_phy_create call.

	Arnd
