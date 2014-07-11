Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaGKNjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:39:18 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64777 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaGKNjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:39:17 -0400
Message-ID: <53BFE8F9.7050700@linaro.org>
Date: Fri, 11 Jul 2014 14:39:05 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 1/2] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
References: <1404903807-26032-1-git-send-email-srinivas.kandagatla@linaro.org> <1404903846-26077-1-git-send-email-srinivas.kandagatla@linaro.org> <1828880.cILxhDlkNH@amdc1032>
In-Reply-To: <1828880.cILxhDlkNH@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou for the comments,

On 11/07/14 13:38, Bartlomiej Zolnierkiewicz wrote:
>
> Hi,
>
> On Wednesday, July 09, 2014 12:04:06 PM Srinivas Kandagatla wrote:
>> Add a PHY driver for uses with AHCI based SATA controller driver on the
>> APQ8064 family of SoCs.
>>
>> This patch is a forward port from Qualcomm's v3.4 andriod kernel.
>
> Android?
yep.
>
> unused define, please remove it
>
Will fix these instances in next version.
>> +
>> +#define UNIPHY_PLL_LOCK		BIT(0)
>> +#define SATA_PHY_TX_CAL		BIT(0)
>> +#define SATA_PHY_RX_CAL		BIT(0)
>> +
>> +/* default timeout set to 1 sec */
>> +#define TIMEOUT_MS		10000
>> +
>> +struct qcom_apq8064_sata_phy {
>> +	void __iomem *mmio;
>> +	struct clk *cfg_clk;
>> +	struct device *dev;
>> +};
>> +
>> +/* Helper function to do poll and timeout */
>> +static int read_poll_timeout(void __iomem *addr, u32 mask)
>> +{
>> +	unsigned long timeout = jiffies + msecs_to_jiffies(TIMEOUT_MS);
>> +	u32 val;
>> +
>> +	do {
>> +		cpu_relax();
>> +		val = readl_relaxed(addr);
>> +		if (val & mask)
>> +			break;
>> +	} while (!time_after(jiffies, timeout));
>
> It would be better to use usleep_[range]() (or even msleep() if needed)
> instead of just using cpu_relax().

We really want to poll the register here, usleep/msleep would be useful 
if we know already know how much delay is required, but in this case the 
its not true.

>> +
>> +static int qcom_apq8064_sata_phy_remove(struct platform_device *pdev)
>> +{
>> +	struct qcom_apq8064_sata_phy *phy = platform_get_drvdata(pdev);
>
> Doesn't this require to use platform_set_drvdata() first in the ->probe
> method?
Good spot, I will fix this in next version.

Thanks,
srini
