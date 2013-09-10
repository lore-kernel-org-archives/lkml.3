Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3IJH3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:29:31 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:65350 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab3IJH33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:29:29 -0400
Date: Tue, 10 Sep 2013 08:29:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: wwang <wei_wang@realsil.com.cn>
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, micky_ching@realsil.com.cn
Subject: Re: [PATCH v2] mfd: rtsx: Modify rts5249_optimize_phy
Message-ID: <20130910072925.GA1456@lee--X1>
References: <cover.1378437776.git.wei_wang@realsil.com.cn>
 <e858b38c5b87dd761c764c6214f49cf9a9b5ad1d.1378437776.git.wei_wang@realsil.com.cn>
 <20130909130211.GG22938@lee--X1>
 <522E7154.7060706@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <522E7154.7060706@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, wwang wrote:

> 于 2013年09月09日 21:02, Lee Jones 写道:
> >>  #define PHY_FLD4			0x1E
> >>>+#define  FLDEN_SEL			0x4000
> >>>+#define  REQ_REF			0x2000
> >>>+#define  RXAMP_OFF			0x1000
> >>>+#define  REQ_ADDA			0x0800
> >>>+#define  BER_COUNT			0x00E0
> >>>+#define  BER_TIMER			0x000A
> >>>+#define  BER_CHK_EN			0x0001
> >>>  #define PHY_DUM_REG			0x1F
> >>>  >  #define LCTLR				0x80
> >This doesn't look right.
> >
> >We had a nicely structured, ordered list and now you've seemingly
> >randomly shoved a truck load of un-prefixed defines between them.
> >
> >Am I missing something? Is there method to the madness?
> 
> Are you suggesting that I should define the macros using the same
> prefix like below?
> 
> #define PHY_FLD4                        0x1E
> #define   FLD4_FLDEN_SEL          0x4000
> #define   FLD4_REQ_REF              0x2000
> #define   FLD4_RXAMP_OFF        0x1000

Ah good, so there was at least some kind of method there. :)

Yes I am, but make them seperate, so perhaps:

/* Phy registers */
 #define PHY_PCR                        0x00
 #define PHY_RCR0                       0x01
 #define PHY_RCR1                       0x02
 #define PHY_RCR2                       0x03

<snip>

+/* Phy bits */
+#define  PHY_PCR_FORCE_CODE            0xB000
+#define  PHY_PCR_OOBS_CALI_50          0x0800
+#define  PHY_PCR_OOBS_VCM_08           0x0200
+#define  PHY_PCR_OOBS_SEN_90           0x0040
+#define  PHY_PCR_RSSI_EN               0x0002

+#define  PHY_RCR1_ADP_TIME             0x0100
+#define  PHY_RCR1_VCO_COARSE           0x001F

+#define  PHY_RCR2_EMPHASE_EN           0x8000
+#define  PHY_RCR2_NADJR                0x4000
+#define  PHY_RCR2_CDR_CP_10            0x0400
+#define  PHY_RCR2_CDR_SR_2             0x0100
+#define  PHY_RCR2_FREQSEL_12           0x0040
+#define  PHY_RCR2_CPADJEN              0x0020
+#define  PHY_RCR2_CDR_SC_8             0x0008
+#define  PHY_RCR2_CALIB_LATE           0x0002

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
