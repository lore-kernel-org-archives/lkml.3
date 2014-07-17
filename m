Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbaGQKgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:36:37 -0400
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:43701 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756055AbaGQKgf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:36:35 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2014 06:36:35 EDT
Date: Thu, 17 Jul 2014 06:26:39 -0400 (EDT)
Subject: RE: Fwd: [PATCH v6 04/12] mmc: mmci: Add Qcom datactrl register variant
From: prakash.burla@smartplayin.com
To: srinivas.kandagatla@linaro.org
Cc: linux@arm.linux.org.uk, ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <CA+neC=Of9Ua5OxUiezmTHfzq9zkXVRCFei3xKMbXi3OGV84EHw@mail.gmail.com>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org> 
 <1401700146-11588-1-git-send-email-srinivas.kandagatla@linaro.org> 
 <CA+neC=Of9Ua5OxUiezmTHfzq9zkXVRCFei3xKMbXi3OGV84EHw@mail.gmail.com>
Message-ID: <1405592799.65820182@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tested-by: Prakash Burla <prakash.burla@smartplayin.com>
This driver tested on AP806X with mmc Driver.

----------------------------------------------------------------------------------
From:  <srinivas.kandagatla@linaro.org>
Date: Mon, Jun 2, 2014 at 2:39 PM
Subject: [PATCH v6 04/12] mmc: mmci: Add Qcom datactrl register variant
To: Russell King <linux@arm.linux.org.uk>, Ulf Hansson
<ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org, Srinivas


From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Instance of this IP on Qualcomm's SOCs has bit different layout for datactrl
register. Bit position datactrl[16:4] hold the true block size instead of power
of 2.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/host/mmci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index ed20bf5..72981f6 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -60,6 +60,8 @@ static unsigned int fmax = 515633;
  * @sdio: variant supports SDIO
  * @st_clkdiv: true if using a ST-specific clock divider algorithm
  * @blksz_datactrl16: true if Block size is at b16..b30 position in
datactrl register
+ * @blksz_datactrl4: true if Block size is at b4..b16 position in datactrl
+ *                  register
  * @pwrreg_powerup: power up value for MMCIPOWER register
  * @signal_direction: input/out direction of bus signals can be indicated
  * @pwrreg_clkgate: MMCIPOWER register must be used to gate the clock
@@ -75,6 +77,7 @@ struct variant_data {
        bool                    sdio;
        bool                    st_clkdiv;
        bool                    blksz_datactrl16;
+       bool                    blksz_datactrl4;
        u32                     pwrreg_powerup;
        bool                    signal_direction;
        bool                    pwrreg_clkgate;
@@ -731,6 +734,8 @@ static void mmci_start_data(struct mmci_host
*host, struct mmc_data *data)

        if (variant->blksz_datactrl16)
                datactrl = MCI_DPSM_ENABLE | (data->blksz << 16);
+       else if (variant->blksz_datactrl4)
+               datactrl = MCI_DPSM_ENABLE | (data->blksz << 4);
        else
                datactrl = MCI_DPSM_ENABLE | blksz_bits << 4;

--
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


