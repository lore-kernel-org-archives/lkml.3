Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738AbaGPG2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:28:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65324 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070AbaGPG2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:28:22 -0400
Message-ID: <53C61B80.5070600@linaro.org>
Date: Wed, 16 Jul 2014 07:28:16 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-ide@vger.kernel.org,
        Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH v4 1/2] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
References: <1405336651-32135-1-git-send-email-srinivas.kandagatla@linaro.org> <1405336679-32179-1-git-send-email-srinivas.kandagatla@linaro.org> <12555066.QsMd3v2SOo@amdc1032>
In-Reply-To: <12555066.QsMd3v2SOo@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 15/07/14 17:56, Bartlomiej Zolnierkiewicz wrote:
>> +
>> >+/* Helper function to do poll and timeout */
>> >+static int read_poll_timeout(void __iomem *addr, u32 mask)
>> >+{
>> >+	unsigned long timeout = jiffies + msecs_to_jiffies(TIMEOUT_MS);
>> >+
>> >+	do {
>> >+		if (readl_relaxed(addr) & mask)
>> >+			return 0;
>> >+
>> >+		 usleep_range(DELAY_INTERVAL_US, DELAY_INTERVAL_US + 50);
>> >+	} while (!time_after(jiffies, timeout));
>> >+
>> >+	return -ETIMEDOUT;
>> >+}
> Thanks for reworking this code, unfortunately it still has a one
> (unlikely but still theoretically possible) problem.  If there is
> i.e. a big IRQ load between first usleep_range() call and first

Very unlikely but as you said it possible in theory :-)

> time_after() check the function will timeout without checking
> the register.  To fix it you needs to add an additonal register
> checking before returning -ETIMEDOUT value or replace time_after()
> condition with a fixed number of retries (100000 to cover 1sec
> timeout).
I will send out a fix on top of my previous patches to fix this.

thanks,
srini
