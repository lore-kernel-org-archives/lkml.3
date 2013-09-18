Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3IROuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:50:18 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13149 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3IROuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:50:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Sep 2013 07:50:15 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 05/12] clk: tegra: add header for common tegra clock IDs
Date: Wed, 18 Sep 2013 17:40:57 +0300
Message-ID: <1379515331-19427-6-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many clocks are common between several Tegra SoCs. Define an enum to list
them so we can move them to separate files which can be shared between
SoCs. Each SoC specific file will provide an array with the common clocks
which are present on the SoC and their DT binding ID.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-id.h |  197 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 197 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-id.h

diff --git a/drivers/clk/tegra/clk-id.h b/drivers/clk/tegra/clk-id.h
new file mode 100644
index 0000000..b2a4d45
--- /dev/null
+++ b/drivers/clk/tegra/clk-id.h
@@ -0,0 +1,197 @@
+/*
+ * This header provides IDs for clocks common between several Tegra SoCs
+ */
+
+#ifndef _TEGRA_CLK_ID_H
+#define _TEGRA_CLK_ID_H
+
+enum clk_id {
+	tegra_clk_rtc,
+	tegra_clk_timer,
+	tegra_clk_uarta,
+	tegra_clk_uartd,
+	tegra_clk_sdmmc2,
+	tegra_clk_i2s1,
+	tegra_clk_i2c1,
+	tegra_clk_ndflash,
+	tegra_clk_sdmmc1,
+	tegra_clk_sdmmc4,
+	tegra_clk_pwm,
+	tegra_clk_i2s0,
+	tegra_clk_i2s2,
+	tegra_clk_epp,
+	tegra_clk_gr_2d,
+	tegra_clk_usbd,
+	tegra_clk_isp,
+	tegra_clk_gr_3d,
+	tegra_clk_disp2,
+	tegra_clk_disp1,
+	tegra_clk_host1x,
+	tegra_clk_vcp,
+
+	tegra_clk_apbdma,
+	tegra_clk_kbc,
+	tegra_clk_kfuse,
+	tegra_clk_sbc1,
+	tegra_clk_nor,
+	tegra_clk_sbc2,
+	tegra_clk_sbc3,
+	tegra_clk_i2c5,
+	tegra_clk_dsia,
+	tegra_clk_mipi,
+	tegra_clk_hdmi,
+	tegra_clk_csi,
+	tegra_clk_i2c2,
+	tegra_clk_uartc,
+	tegra_clk_mipi_cal,
+	tegra_clk_emc,
+	tegra_clk_usb2,
+	tegra_clk_usb3,
+	tegra_clk_vde,
+	tegra_clk_bsea,
+	tegra_clk_bsev,
+
+	tegra_clk_i2c3,
+	tegra_clk_sbc4,
+	tegra_clk_sdmmc3,
+	tegra_clk_owr,
+	tegra_clk_csite,
+	tegra_clk_la,
+	tegra_clk_trace,
+	tegra_clk_soc_therm,
+	tegra_clk_dtv,
+	tegra_clk_ndspeed,
+	tegra_clk_i2cslow,
+	tegra_clk_dsib,
+	tegra_clk_tsec,
+	tegra_clk_xusb_host,
+	tegra_clk_msenc,
+	tegra_clk_csus,
+
+	tegra_clk_mselect,
+	tegra_clk_tsensor,
+	tegra_clk_i2s3,
+	tegra_clk_i2s4,
+	tegra_clk_i2c4,
+	tegra_clk_sbc5,
+	tegra_clk_sbc6,
+	tegra_clk_d_audio,
+	tegra_clk_apbif,
+	tegra_clk_dam0,
+	tegra_clk_dam1,
+	tegra_clk_dam2,
+	tegra_clk_hda2codec_2x,
+	tegra_clk_audio0_2x,
+	tegra_clk_audio1_2x,
+	tegra_clk_audio2_2x,
+	tegra_clk_audio3_2x,
+	tegra_clk_audio4_2x,
+	tegra_clk_spdif_2x,
+	tegra_clk_actmon,
+	tegra_clk_extern1,
+	tegra_clk_extern2,
+	tegra_clk_extern3,
+	tegra_clk_hda,
+	tegra_clk_se,
+
+	tegra_clk_hda2hdmi,
+	tegra_clk_cilab,
+	tegra_clk_cilcd,
+	tegra_clk_cile,
+	tegra_clk_dsialp,
+	tegra_clk_dsiblp,
+	tegra_clk_dds,
+	tegra_clk_dp2,
+	tegra_clk_amx,
+	tegra_clk_adx,
+	tegra_clk_xusb_ss,
+
+	tegra_clk_uartb,
+	tegra_clk_vfir,
+	tegra_clk_spdif_in,
+	tegra_clk_spdif_out,
+	tegra_clk_vi,
+	tegra_clk_vi_sensor,
+	tegra_clk_fuse,
+	tegra_clk_fuse_burn,
+	tegra_clk_clk_32k,
+	tegra_clk_clk_m,
+	tegra_clk_clk_m_div2,
+	tegra_clk_clk_m_div4,
+	tegra_clk_pll_ref,
+	tegra_clk_pll_c,
+	tegra_clk_pll_c_out1,
+	tegra_clk_pll_c2,
+	tegra_clk_pll_c3,
+	tegra_clk_pll_m,
+	tegra_clk_pll_m_out1,
+	tegra_clk_pll_p,
+	tegra_clk_pll_p_out1,
+	tegra_clk_pll_p_out2,
+	tegra_clk_pll_p_out3,
+	tegra_clk_pll_p_out4,
+	tegra_clk_pll_a,
+	tegra_clk_pll_a_out0,
+	tegra_clk_pll_d,
+	tegra_clk_pll_d_out0,
+	tegra_clk_pll_d2,
+	tegra_clk_pll_d2_out0,
+	tegra_clk_pll_u,
+	tegra_clk_pll_u_480m,
+
+	tegra_clk_pll_u_60m,
+	tegra_clk_pll_u_48m,
+	tegra_clk_pll_u_12m,
+	tegra_clk_pll_x,
+	tegra_clk_pll_x_out0,
+	tegra_clk_pll_re_vco,
+	tegra_clk_pll_re_out,
+	tegra_clk_pll_e_out0,
+	tegra_clk_spdif_in_sync,
+	tegra_clk_i2s0_sync,
+	tegra_clk_i2s1_sync,
+	tegra_clk_i2s2_sync,
+	tegra_clk_i2s3_sync,
+	tegra_clk_i2s4_sync,
+	tegra_clk_vimclk_sync,
+	tegra_clk_audio0,
+	tegra_clk_audio1,
+	tegra_clk_audio2,
+	tegra_clk_audio3,
+	tegra_clk_audio4,
+	tegra_clk_spdif,
+	tegra_clk_clk_out_1,
+	tegra_clk_clk_out_2,
+	tegra_clk_clk_out_3,
+	tegra_clk_blink,
+	tegra_clk_xusb_host_src,
+	tegra_clk_xusb_falcon_src,
+	tegra_clk_xusb_fs_src,
+	tegra_clk_xusb_ss_src,
+
+	tegra_clk_xusb_dev_src,
+	tegra_clk_xusb_dev,
+	tegra_clk_xusb_hs_src,
+	tegra_clk_sclk,
+	tegra_clk_hclk,
+	tegra_clk_pclk,
+	tegra_clk_cclk_g,
+	tegra_clk_cclk_lp,
+	tegra_clk_dfll_ref,
+	tegra_clk_dfll_soc,
+
+	tegra_clk_audio0_mux,
+	tegra_clk_audio1_mux,
+	tegra_clk_audio2_mux,
+	tegra_clk_audio3_mux,
+	tegra_clk_audio4_mux,
+	tegra_clk_spdif_mux,
+	tegra_clk_clk_out_1_mux,
+	tegra_clk_clk_out_2_mux,
+	tegra_clk_clk_out_3_mux,
+	tegra_clk_dsia_mux,
+	tegra_clk_dsib_mux,
+	tegra_clk_max,
+};
+
+#endif	/* _TEGRA_CLK_ID_H */
-- 
1.7.7.rc0.72.g4b5ea.dirty

