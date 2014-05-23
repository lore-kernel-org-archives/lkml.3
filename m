Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaEWSw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:52:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55402 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaEWSw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:52:26 -0400
Message-ID: <537F98E8.6050203@codeaurora.org>
Date: Fri, 23 May 2014 11:52:24 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Patch v2 3/4] soc: qcom: Add GSBI driver
References: <1398357082-5102-1-git-send-email-agross@codeaurora.org> <1398357082-5102-4-git-send-email-agross@codeaurora.org>
In-Reply-To: <1398357082-5102-4-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/14 09:31, Andy Gross wrote:
> +
> +static const struct of_device_id gsbi_dt_match[] = {
> +	{ .compatible = "qcom,gsbi-v1.0.0", },
> +};

Eek. This isn't NULL terminated.


-----8<---

From: Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH] soc: qcom: Terminate gsbi of match table

Failure to terminate this match table can lead to boot failures
depending on where the compiler places the match table.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/soc/qcom/qcom_gsbi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/qcom_gsbi.c b/drivers/soc/qcom/qcom_gsbi.c
index 061dd0632dbd..ab7b441c9980 100644
--- a/drivers/soc/qcom/qcom_gsbi.c
+++ b/drivers/soc/qcom/qcom_gsbi.c
@@ -64,6 +64,7 @@ static int gsbi_probe(struct platform_device *pdev)
 
 static const struct of_device_id gsbi_dt_match[] = {
 	{ .compatible = "qcom,gsbi-v1.0.0", },
+	{ }
 };
 
 MODULE_DEVICE_TABLE(of, gsbi_dt_match);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

