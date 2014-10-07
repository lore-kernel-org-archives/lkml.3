Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaJGXHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:07:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53723 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaJGXHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:07:45 -0400
Message-ID: <5434723F.70800@codeaurora.org>
Date: Tue, 07 Oct 2014 16:07:43 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: qcom: add description of KPSS WDT for IPQ8064
References: <cover.1412182773.git.joshc@codeaurora.org> <50c0ec1514173ce07641a95839e939dcda41b110.1412182773.git.joshc@codeaurora.org> <20141001172855.GL10233@codeaurora.org> <20141001181557.GQ868@joshc.qualcomm.com> <542DA2B6.3020201@codeaurora.org> <20141007221044.GR868@joshc.qualcomm.com>
In-Reply-To: <20141007221044.GR868@joshc.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 03:10 PM, Josh Cartwright wrote:
> On Thu, Oct 02, 2014 at 12:08:38PM -0700, Stephen Boyd wrote:
> [..]
>> On 10/01/14 11:15, Josh Cartwright wrote:
>>> Something like this perhaps:
>>>
>>> 	timer@200a000 {
>>> 		compatible = "qcom,kpss-timer", "qcom,msm-timer";
>>> 		interrupts = <1 1 0x301>,
>>> 			     <1 2 0x301>,
>>> 			     <1 3 0x301>;
>>> 		reg = <0x0200a000 0x100>;
>>> 		clock-frequency = <25000000>,
>>> 				  <32768>;
>>> 		cpu-offset = <0x80000>;
>>>
>>> 		#address-cells = <1>;
>>> 		#size-cells = <1>;
>>> 		ranges;
>>>
>>> 		cpu0_wdt0: watchdog@208a038 {
>>> 			compatible = "qcom,kpss-wdt";
>>> 			reg = <0x208a038 0x40>;
>>> 			interrupts = <1 4 0x301>,
>>> 			clocks = <&sleep_clk>;
>>> 			timeout-sec = <10>;
>>> 			cpu = <&cpu0>;
>>> 		};
>>>
>>> 		cpu0_wdt1: watchdog@208a060 {
>>> 			compatible = "qcom,kpss-wdt";
>>> 			reg = <0x208a060 0x40>;
>>> 			interrupts = <1 5 0x301>,
>>> 			clocks = <&sleep_clk>;
>>> 			timeout-sec = <20>;
>>> 			cpu = <&cpu0>;
>>> 		};
>>>
>>> 		cpu1_wdt0: watchdog@209a038 {
>>> 			compatible = "qcom,kpss-wdt";
>>> 			reg = <0x209a038 0x40>;
>>> 			interrupts = <1 4 0x301>,
>>> 			clocks = <&sleep_clk>;
>>> 			timeout-sec = <8>;
>>> 			cpu = <&cpu1>;
>>> 		};
>>>
>>> 		cpu1_wdt1: watchdog@209a060 {
>>> 			compatible = "qcom,kpss-wdt";
>>> 			reg = <0x209a060 0x40>;
>>> 			interrupts = <1 5 0x301>,
>>> 			clocks = <&sleep_clk>;
>>> 			timeout-sec = <15>;
>>> 			cpu = <&cpu1>;
>>> 		};
>>> 	};
>>>
>>>
>> I'm thinking:
>>
>>                  timer@200a000 {
>>                          compatible = "qcom,kpss-timer", "qcom,msm-timer";
>>                          interrupts = <1 1 0x301>,
>>                                       <1 2 0x301>,
>>                                       <1 3 0x301>,
>>                                       <1 4 0x301>,
>>                                       <1 5 0x301>;
>>                          reg = <0x0200a000 0x100>;
>>                          clock-frequency = <27000000>,
>>                                            <32768>;
>>                          clocks = <&cxo>, <&sleep_clk>;
>>                          clock-names = "ref", "sleep";
>>                          cpu-offset = <0x80000>;
>>                  };
> Where'd the default timeout configuration go?  Or, should we have one
> timeout-sec property and not allow setting the default timeouts per WDT
> instance?  Or no configurable timeout at all?

Ah sorry. How about a timeout-sec-0, timeout-sec-1 property that is 
per-cpu and maps to the first and second watchdog timer? Something like:

timeout-sec-wdt0 = <10 8>;
timeout-sec-wdt1 = <20 15>;

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

