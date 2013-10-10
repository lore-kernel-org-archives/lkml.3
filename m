Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab3JJMd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:33:26 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:53047 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779Ab3JJMdY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:33:24 -0400
From: Stephen GALLIMORE <stephen.gallimore@st.com>
To: Maxime COQUELIN <maxime.coquelin@st.com>, Wolfram Sang <wsa@the-dreams.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Cc: Stuart MENEFY <stuart.menefy@st.com>, Lee Jones <lee.jones@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Date: Thu, 10 Oct 2013 14:33:19 +0200
Subject: RE: [PATCH v4 3/4] ARM: STi: Supply I2C configuration to STiH415 SoC
Thread-Topic: [PATCH v4 3/4] ARM: STi: Supply I2C configuration to STiH415
 SoC
Thread-Index: Ac7ERXheXPHWFAcjSxKNzyxfYcoHCwBbWevg
Message-ID: <A3BF01DB4A606149A4C20C4C4C808F6C5BC8A70D4E@SAFEX1MAIL1.st.com>
References: <1381250576-7916-1-git-send-email-maxime.coquelin@st.com>
 <1381250576-7916-4-git-send-email-maxime.coquelin@st.com>
In-Reply-To: <1381250576-7916-4-git-send-email-maxime.coquelin@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Maxime COQUELIN [mailto:maxime.coquelin@st.com]
> Sent: 08 October 2013 17:43
>.....
> +
> +		i2c@fed40000 {
> +			compatible	= "st,comms-ssc-i2c";
> +			reg		= <0xfed40000 0x110>;
> +			interrupts	=  <GIC_SPI 187 IRQ_TYPE_EDGE_RISING>;

This should specify level (high) triggered, not edge triggered, for our
SoC integrations.

Note that level triggered is the default GIC setup and was therefore
what was being used when you specified "0" for the flags previously.

> +			clocks		= <&CLKS_ICN_REG_0>;
> +			clock-names	= "ssc";
> +			clock-frequency = <400000>;
> +			pinctrl-names	= "default";
> +			pinctrl-0	= <&pinctrl_i2c0_default>;
> +
> +			status		= "disabled";
> +		};

