Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaE1US6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:18:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59836 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaE1US4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:18:56 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] ARM: dts: qcom: Update msm8960 device trees
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140528200948.GI2012@joshc.qualcomm.com>
Date: Wed, 28 May 2014 15:18:51 -0500
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7C29E7CF-F9A4-4BCE-99AC-2C12FD22258F@codeaurora.org>
References: <1401301643-20191-1-git-send-email-galak@codeaurora.org> <20140528200948.GI2012@joshc.qualcomm.com>
To: Josh Cartwright <joshc@codeaurora.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 28, 2014, at 3:09 PM, Josh Cartwright <joshc@codeaurora.org> wrote:

> On Wed, May 28, 2014 at 01:27:23PM -0500, Kumar Gala wrote:
>> * Move SoC peripherals into an SoC container node
>> * Move serial enabling into board file (qcom-msm8960-cdp.dts)
>> * Cleanup cpu node to match binding spec, enable-method and compatible
>>  should be per cpu, not part of the container
>> * Drop interrupts property from l2-cache node as its not part of the
>>  binding spec
>> 
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> arch/arm/boot/dts/qcom-msm8960-cdp.dts |   6 ++
>> arch/arm/boot/dts/qcom-msm8960.dtsi    | 165 +++++++++++++++++----------------
>> 2 files changed, 93 insertions(+), 78 deletions(-)
>> 
>> diff --git a/arch/arm/boot/dts/qcom-msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
>> index a58fb88..8e77ed7 100644
>> --- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
>> +++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
>> @@ -3,4 +3,10 @@
>> / {
>> 	model = "Qualcomm MSM8960 CDP";
>> 	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
>> +
>> +	soc {
>> +		serial@16440000 {
>> +			status = "ok";
>> +		};
>> +	};
>> };
> 
> Is now the time put these serial nodes under a GSBI parent node?

Yeah, I’ll make the change to the 8960 & 8660 dts

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

