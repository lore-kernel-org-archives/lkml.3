Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbbAPTYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:24:14 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:56790 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbbAPTYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:24:12 -0500
X-IronPort-AV: E=Sophos;i="5.09,412,1418112000"; 
   d="scan'208";a="55160822"
Message-ID: <54B96559.1010007@broadcom.com>
Date: Fri, 16 Jan 2015 11:24:09 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Scott Branden" <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] ARM: dts: add I2C device nodes for Broadcom Cygnus
References: <rjui@broadcom.com> <1421274213-3544-1-git-send-email-rjui@broadcom.com> <1421274213-3544-4-git-send-email-rjui@broadcom.com> <20150115084456.GO22880@pengutronix.de>
In-Reply-To: <20150115084456.GO22880@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/15/2015 12:44 AM, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Jan 14, 2015 at 02:23:33PM -0800, Ray Jui wrote:
>> Add I2C device nodes and its properties in bcm-cygnus.dtsi but keep
>> them disabled there. Individual I2C devices can be enabled in board
>> specific dts file when I2C slave devices are enabled in the future
> s/$/./
> 
>>
>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>  arch/arm/boot/dts/bcm-cygnus.dtsi |   20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
>> index 5126f9e..f7d6c1d 100644
>> --- a/arch/arm/boot/dts/bcm-cygnus.dtsi
>> +++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
>> @@ -70,6 +70,26 @@
>>  		};
>>  	};
>>  
>> +	i2c0: i2c@18008000 {
>> +		compatible = "brcm,iproc-i2c";
> in patch 2 you wrote the driver is for a family of SoCs, right? Then I'd
> make this:
> 
> 	compatible = "brcm,$mysoc-iproc-i2c", "brcm,iproc-i2c";
> 
Sorry could you please help to explain the intention here? Note the
iProc I2C IP can be found in various iProc family of SoCs, but to my
best knowledge, there hasn't been any changes of the IP in any of those
SoCs.

Is the compatible ID "brcm,$mysoc-iproc-i2c" only to clarify that it's
for a specific SoC? If so, what should the compatible ID array look
like? Should it be changed to the following?

static const struct of_device_id bcm_iproc_i2c_of_match[] = {
	{ .compatible = "brcm,iproc-i2c" },
	{ .compatible = "brcm,$mysoc-iproc-i2c" },
	{},
};


> (or maybe s/$mysoc-iproc-i2c/$mysoc-i2c/).
> 
> Best regards
> Uwe
> 
