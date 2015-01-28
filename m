Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbbA2Br6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:47:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37976 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbbA2Brx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:47:53 -0500
Date: Wed, 28 Jan 2015 17:18:47 -0600
From: Andy Gross <agross@codeaurora.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Joonwoo Park <joonwoop@codeaurora.org>
Subject: Re: [PATCH 3/3] pinctrl: qcom: Add msm8916 pinctrl driver
Message-ID: <20150128231847.GC17315@qualcomm.com>
References: <1421745476-6276-1-git-send-email-svarbanov@mm-sol.com>
 <1421745476-6276-4-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421745476-6276-4-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:17:56AM +0200, Stanimir Varbanov wrote:

<snip>

> +	MSM_MUX_blsp1_spi,
> +	MSM_MUX_blsp2_spi,
> +	MSM_MUX_blsp3_spi,

The above three need to be renamed to blsp_spiX_csX to denote which SPI and chip
select they modify.

> +	MSM_MUX_blsp_i2c1,
> +	MSM_MUX_blsp_i2c2,
> +	MSM_MUX_blsp_i2c3,
> +	MSM_MUX_blsp_i2c4,
> +	MSM_MUX_blsp_i2c5,
> +	MSM_MUX_blsp_i2c6,
> +	MSM_MUX_blsp_spi1,
> +	MSM_MUX_blsp_spi2,
> +	MSM_MUX_blsp_spi3,
> +	MSM_MUX_blsp_spi4,
> +	MSM_MUX_blsp_spi5,
> +	MSM_MUX_blsp_spi6,

<snip>

> +	MSM_MUX_uim1_clk,
> +	MSM_MUX_uim1_data,
> +	MSM_MUX_uim1_present,
> +	MSM_MUX_uim1_reset,
> +	MSM_MUX_uim2_clk,
> +	MSM_MUX_uim2_data,
> +	MSM_MUX_uim2_present,
> +	MSM_MUX_uim2_reset,
> +	MSM_MUX_uim3_clk,
> +	MSM_MUX_uim3_data,
> +	MSM_MUX_uim3_present,
> +	MSM_MUX_uim3_reset,

Can the UIM be collapsed into uim1, uim2, uim3?

> +	MSM_MUX_uim_batt,
> +	MSM_MUX_wcss_bt,
> +	MSM_MUX_wcss_fm,
> +	MSM_MUX_wcss_wlan,
> +	MSM_MUX_wcss_wlan0,
> +	MSM_MUX_wcss_wlan1,
> +	MSM_MUX_wcss_wlan2,

Can the wcss_wlan0/1/2 be collapsed down into wlan?

> +	MSM_MUX_webcam1_rst,
> +	MSM_MUX_NA,
> +};

<snip>


> +	PINGROUP(9, blsp_spi3, qdss_tracedata_a, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(10, blsp_spi3, blsp_i2c3, qdss_tracedata_a, NA, NA, NA, NA, NA,
> +		 NA),
> +	PINGROUP(11, blsp_spi3, blsp_i2c3, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(12, blsp_spi4, gcc_gp2_clk_b, NA, atest_combodac, NA, NA, NA,
> +		 NA, NA),
> +	PINGROUP(13, blsp_spi4, gcc_gp3_clk_b, NA, atest_combodac, NA, NA, NA,
> +		 NA, NA),
> +	PINGROUP(14, blsp_spi4, blsp_i2c4, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(15, blsp_spi4, blsp_i2c4, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(16, blsp_spi5, blsp1_spi, NA, atest_bbrx1, NA, NA, NA, NA, NA),

The blsp1_spi is cs2.  We usually denote these as separate from the blspX_spi.
And we should probably call it blsp_spi1_cs2

> +	PINGROUP(17, blsp_spi5, blsp2_spi, NA, atest_bbrx0, NA, NA, NA, NA, NA),

The blsp2_spi is cs2.  We usually denote these as separate from the blspX_spi.
And we should probably call it blsp_spi2_cs2

> +	PINGROUP(18, blsp_spi5, blsp_i2c5, NA, atest_gpsadc1, NA, NA, NA, NA,
> +		 NA),
> +	PINGROUP(19, blsp_spi5, blsp_i2c5, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(20, blsp_spi6, NA, NA, NA, NA, NA, NA, qdss_cti_trig_in_a0,
> +		 NA),
> +	PINGROUP(21, blsp_spi6, NA, NA, NA, NA, NA, NA, qdss_cti_trig_in_b0,
> +		 NA),
> +	PINGROUP(22, blsp_spi6, blsp_i2c6, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(23, blsp_spi6, blsp_i2c6, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(24, mdp_vsync, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(25, mdp_vsync, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(26, cam_mclk, NA, NA, NA, NA, NA, qdss_tracedata_b, NA, NA),

cam_mclk0?

> +	PINGROUP(27, cam_mclk, NA, NA, NA, NA, NA, NA, NA, qdss_tracedata_b),

cam_mclk1?

> +	PINGROUP(28, pwr_modem_enabled_a, NA, NA, NA, NA, NA, qdss_tracedata_b,
> +		 NA, atest_combodac),
> +	PINGROUP(29, cci_i2c, NA, NA, NA, NA, NA, qdss_tracedata_b, NA,
> +		 atest_combodac),
> +	PINGROUP(30, cci_i2c, NA, NA, NA, NA, NA, NA, NA, qdss_tracedata_b),
> +	PINGROUP(31, cci_timer0, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(32, cci_timer1, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(33, cci_async, NA, NA, NA, NA, NA, NA, NA, qdss_tracedata_b),
> +	PINGROUP(34, pwr_nav_enabled_a, NA, NA, NA, NA, NA, NA, NA,
> +		 qdss_tracedata_b),
> +	PINGROUP(35, pwr_crypto_enabled_a, NA, NA, NA, NA, NA, NA, NA,
> +		 qdss_tracedata_b),
> +	PINGROUP(36, NA, NA, NA, NA, NA, NA, NA, qdss_tracedata_b, NA),
> +	PINGROUP(37, blsp3_spi, NA, NA, NA, NA, NA, qdss_tracedata_b, NA, NA),

See above for chip selects..... blsp_spi3_cs2

> +	PINGROUP(38, cci_timer2, adsp_ext, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(39, wcss_bt, qdss_tracedata_a, NA, atest_combodac, NA, NA, NA,
> +		 NA, NA),
> +	PINGROUP(40, wcss_wlan2, qdss_tracedata_a, NA, atest_combodac, NA, NA,

Use wlan_data instead?  This is data pin 2 for wlan_data. or use wcss_wlan

> +		 NA, NA, NA),
> +	PINGROUP(41, wcss_wlan1, qdss_tracedata_a, NA, atest_combodac, NA, NA,

Use wlan_data instead?  This is data pin 1 for wlan_data. or use wcss_wlan

> +		 NA, NA, NA),
> +	PINGROUP(42, wcss_wlan0, qdss_tracedata_a, NA, atest_combodac, NA, NA,

Use wlan_data instead?  This is data pin 0 for wlan_data. or use wcss_wlan

> +		 NA, NA, NA),
> +	PINGROUP(43, wcss_wlan, prng_rosc, qdss_tracedata_a, NA, atest_combodac,
> +		 NA, NA, NA, NA),
> +	PINGROUP(44, wcss_wlan, NA, atest_combodac, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(45, wcss_fm, ext_lpass, qdss_tracectl_a, NA, atest_combodac,

<snip>

> +	PINGROUP(67, cdc_pdm0, ebi0_wrcdc, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(68, cdc_pdm0, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(69, blsp3_spi, qdss_tracedata_a, NA, atest_combodac, NA, NA,

See above spi chip selects..... blsp_spi3_cs3

> +		 NA, NA, NA),
> +	PINGROUP(70, NA, NA, NA, NA, NA, NA, NA, NA, NA),

<snip>

> +	PINGROUP(109, pbs2, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(110, blsp1_spi, pri_mi2s_ws, NA, qdss_tracedata_b, NA, NA, NA,

See above spi chip selects..... blsp_spi1_cs1

> +		 NA, NA),
> +	PINGROUP(111, qdss_tracedata_b, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(112, sec_mi2s, NA, NA, NA, qdss_tracedata_a, NA, atest_tsens,
> +		 NA, NA),
> +	PINGROUP(113, pri_mi2s, NA, pwr_modem_enabled_b, NA, NA, NA, NA, NA,
> +		 qdss_tracedata_a),
> +	PINGROUP(114, pri_mi2s, pwr_nav_enabled_b, NA, NA, NA, NA, NA,
> +		 qdss_tracedata_a, NA),
> +	PINGROUP(115, pri_mi2s, pwr_crypto_enabled_b, NA, NA, NA, NA, NA,
> +		 qdss_tracedata_a, NA),
> +	PINGROUP(116, pri_mi2s, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(117, sec_mi2s, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(118, sec_mi2s, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(119, sec_mi2s, m_voc, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(120, blsp3_spi, ldo_update, NA, NA, NA, NA, NA, NA, NA),

See above spi chip selects..... blsp_spi3_cs1

> +	PINGROUP(121, sd_write, blsp2_spi, ldo_en, NA, NA, NA, NA, NA, NA),

See above spi chip selects..... blsp_spi2_cs1

> +	SDC_PINGROUP(sdc1_clk, 0x10a000, 13, 6),
> +	SDC_PINGROUP(sdc1_cmd, 0x10a000, 11, 3),
> +	SDC_PINGROUP(sdc1_data, 0x10a000, 9, 0),

<snip>

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

