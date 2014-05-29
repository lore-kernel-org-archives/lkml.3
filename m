Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbaE2Qaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:30:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49012 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaE2Qah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:30:37 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT binding
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <53875E17.6010406@linaro.org>
Date: Thu, 29 May 2014 11:30:31 -0500
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <7FA6C80D-8076-4E41-AF55-11BBA2FD9AB0@codeaurora.org>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com> <1401211721-19712-2-git-send-email-bjorn.andersson@sonymobile.com> <53875E17.6010406@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 29, 2014, at 11:19 AM, Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:

>> += SUBDEVICES
>> +
>> +The RPM exposes resources to its subnodes. The below bindings specify the set
>> +of valid subnodes that can operate on these resources.
> 
> Why should these devices be on sub nodes?
> 
> Any reason not to implement it like this,
> 
> rpm: rpm@108000 {
> 	compatible = "qcom,rpm-msm8960";
> 	reg = <0x108000 0x1000 0x2011008 0x4>;
> 
> 	interrupts = <0 19 0>, <0 21 0>, <0 22 0>;
> 	interrupt-names = "ack", "err", "wakeup";
> };
> 
> pm8921_s1: pm8921-s1 {
> 	compatible = "qcom,rpm-pm8921-smps";
> 	
> 	regulator-min-microvolt = <1225000>;
> 	regulator-max-microvolt = <1225000>;
> 	regulator-always-on;
> 
> 	qcom,rpm = <&rpm QCOM_RPM_PM8921_S1>;
> 	qcom,switch-mode-frequency = <3200000>;
> 	qcom,hpm-threshold = <100000>;
> };
> 
> This would simplify the driver code too and handle the interface neatly then depending on device hierarchy.
> rpm would be a interface library to the clients. Makes the drivers more independent, and re-usable if we do this way.
> 
> ??

One reason to go with sub nodes is it creates a proper driver ordering dependency as I assume rpm driver will end up calling of_platform_populate for the sub nodes at the point that the RPM driver is ready.  We could do this with deferred probe but doing it explicitly is better in my opinion as it limits the amount of time between when RPM is ready vs when the children can start doing things

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

