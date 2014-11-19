Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaKSF1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 00:27:52 -0500
Received: from mout.web.de ([212.227.15.4]:59470 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbaKSF1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 00:27:50 -0500
Message-ID: <546C2A13.3010307@web.de>
Date: Wed, 19 Nov 2014 06:26:43 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>, Robin Gong <b38343@freescale.com>
CC: kernel@pengutronix.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, sre@kernel.org,
        dbaryshkov@gmail.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: dts: imx6: add pm_power_off support for i.mx6
 chips
References: <1415780439-29728-1-git-send-email-b38343@freescale.com> <1415780439-29728-2-git-send-email-b38343@freescale.com> <20141119031823.GC27759@dragon>
In-Reply-To: <20141119031823.GC27759@dragon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:JjymxUeng6RdhjiVYLR22egM8rvmT3XdFiWID16DdIpgzaccQhO
 Wxtq43MyE8oILE1EIoJIw83NNcCfIYa/getmAFnpBgrU39i+hEm7BTaOf5TEfozJfnhUUe7
 PzvE4gZBxSaSzy9yyZKNQE8WgWuDpKnnwvLOj8d9G2gZQAYwZZaVBWV3kIioBtZQ8Z4ITsj
 pLRKYUWMxQVRzFwM5Y4gw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19.11.2014 04:18, Shawn Guo wrote:
> On Wed, Nov 12, 2014 at 04:20:37PM +0800, Robin Gong wrote:
>> All chips of i.mx6 can be powered off by programming SNVS.
>> For example :
>> On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
>> pmic ON/OFF pin, that will cause the whole PMIC powered off
>> except VSNVS. And system can restart once PMIC_ON_REQ goes
>> high by push POWRER key.
>>
>> Signed-off-by: Robin Gong <b38343@freescale.com>
>> ---
>>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi |    4 ++++
>>  arch/arm/boot/dts/imx6qdl.dtsi         |    6 ++++++
>>  arch/arm/boot/dts/imx6sl-evk.dts       |    4 ++++
>>  arch/arm/boot/dts/imx6sl.dtsi          |    6 ++++++
>>  arch/arm/boot/dts/imx6sx-sdb.dts       |    4 ++++
>>  arch/arm/boot/dts/imx6sx.dtsi          |    6 ++++++
>>  6 files changed, 30 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
>> index 07fb302..ba12cc6 100644
>> --- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
>> +++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
>> @@ -531,6 +531,10 @@
>>  	status = "okay";
>>  };
>>  
>> +&snvs-poweroff {
>> +	status = "okay";
>> +};"
>> +
>>  &ssi2 {
>>  	status = "okay";
>>  };
>> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
>> index c701af9..3a032d1 100644
>> --- a/arch/arm/boot/dts/imx6qdl.dtsi
>> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
>> @@ -645,6 +645,12 @@
>>  					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
>>  						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
>>  				};
>> +
>> +				snvs-poweroff: snvs-poweroff@38 {
> 
> I'm not sure if it's because my DTC version is too low or you didn't
> test, the DTC reports error in label name 'snvs-poweroff'.  IIRC, hyphen
> '-' cannot be used in label name, but underscore '_' can.
> 
> Shawn

In the patch series "[PATCH v4 0/3] add power off driver for i.mx6" from
Sep 26 (what I have tested) snvs_poweroff was used. This worked as expected.

So this series "[PATCH v4 0/3] add power off driver for i.mx6" (sent on
Nov 12) apparently contains old patches and is not simply resent as
stated in the cover letter.

Soeren
