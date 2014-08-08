Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaHHF24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:28:56 -0400
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:40159 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaHHF2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:28:55 -0400
Message-ID: <53E4600C.4030505@de.bosch.com>
Date: Fri, 8 Aug 2014 07:28:44 +0200
From: Dirk Behme <dirk.behme@de.bosch.com>
Organization: Robert Bosch Car Multimedia GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <mathieu.poirier@linaro.org>
CC: <linus.walleij@linaro.org>, <will.deacon@arm.com>,
        <linux@arm.linux.org.uk>, <robherring2@gmail.com>,
        <daniel.thompson@linaro.org>, <robbelibobban@gmail.com>,
        <Al.Grant@arm.com>, <patches@linaro.org>, <marcin.jabrzyk@gmail.com>,
        <linux-kernel@vger.kernel.org>, <panchaxari.prasannamurthy@linaro.org>,
        <r.sengupta@samsung.com>, <arve@android.com>,
        <Tony.Armitstead@arm.com>, <john.stultz@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <james.king@linaro.org>,
        <pratikp@codeaurora.org>, <varshney@ti.com>,
        <jonas.svennebring@avagotech.com>
Subject: Re: [PATCH 07/10 v3] coresight-etm: add CoreSight ETM/PTM driver
References: <1407435706-19441-1-git-send-email-mathieu.poirier@linaro.org> <1407435706-19441-8-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1407435706-19441-8-git-send-email-mathieu.poirier@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.211.33]
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.08.2014 20:21, mathieu.poirier@linaro.org wrote:
> From: Pratik Patel <pratikp@codeaurora.org>
>
> This driver manages CoreSight ETM (Embedded Trace Macrocell) that
> supports processor tracing. Currently supported version are ARM
> ETMv3.x and PTM1.x.
>
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
...
> +static struct amba_id etm_ids[] = {
> +	{	/* ETM 3.3 */
> +		.id	= 0x0003b921,
> +		.mask	= 0x0003ffff,
> +	},
> +	{	/* ETM 3.5 */
> +		.id	= 0x0003b956,
> +		.mask	= 0x0003ffff,
> +	},
> +	{	/* PTM */
> +		.id	= 0x0003b95f,
> +		.mask	= 0x0003ffff,
> +	},
> +	{ 0, 0},

Maybe you like to add PTM 1.0 [1] here, too?

Best regards

Dirk

[1]

diff --git a/drivers/coresight/coresight-etm.c 
b/drivers/coresight/coresight-etm.c
index 6f5dbc7..a7a08e6 100644
--- a/drivers/coresight/coresight-etm.c
+++ b/drivers/coresight/coresight-etm.c
@@ -1284,6 +1284,8 @@ static bool etm_arch_supported(u8 arch)
  		break;
  	case ETM_ARCH_V3_5:
  		break;
+	case PFT_ARCH_V1_0:
+		break;
  	case PFT_ARCH_V1_1:
  		break;
  	default:
@@ -1418,6 +1420,7 @@ static int etm_probe(struct amba_device *adev, 
const struct amba_id *id)
  	put_online_cpus();

  	if (etm_arch_supported(drvdata->arch) == false) {
+		dev_err(dev, "ETM arch 0x%02x not supported\n", drvdata->arch);
  		ret = -EINVAL;
  		goto err_arch_supported;
  	}
@@ -1472,11 +1475,15 @@ static struct amba_id etm_ids[] = {
  		.id	= 0x0003b921,
  		.mask	= 0x0003ffff,
  	},
+	{	/* PTM 1.0 */
+		.id	= 0x0003b950,
+		.mask	= 0x0003ffff,
+	},
  	{	/* ETM 3.5 */
  		.id	= 0x0003b956,
  		.mask	= 0x0003ffff,
  	},
-	{	/* PTM */
+	{	/* PTM 1.1 */
  		.id	= 0x0003b95f,
  		.mask	= 0x0003ffff,
  	},
diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index a19420e..596ec94 100644
--- a/include/linux/coresight.h
+++ b/include/linux/coresight.h
@@ -32,6 +32,7 @@

  #define ETM_ARCH_V3_3		(0x23)
  #define ETM_ARCH_V3_5		(0x25)
+#define PFT_ARCH_V1_0		(0x30)
  #define PFT_ARCH_V1_1		(0x31)

  #define CORESIGHT_UNLOCK	(0xC5ACCE55)

