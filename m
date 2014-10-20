Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaJTOiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:38:55 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:43377 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaJTOiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:38:52 -0400
Message-ID: <54451E72.6060900@mm-sol.com>
Date: Mon, 20 Oct 2014 17:38:42 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] ARM: DT: apq8064: Add Support for SD Card Detect for
 ifc6410 board
References: <1413805194-4360-1-git-send-email-pramod.gurav@smartplayin.com> <5444F62D.1090801@smartplayin.com>
In-Reply-To: <5444F62D.1090801@smartplayin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 02:46 PM, Pramod Gurav wrote:
> +linux-arm-msm
> 
> On Monday 20 October 2014 05:09 PM, Pramod Gurav wrote:
>> This changes muxes in gpio26 pin to function as gpio and adds support
>> for sd card detect for apq8064 based IFC6410 board.
>>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>>
>> ---
>>  arch/arm/boot/dts/qcom-apq8064-ifc6410.dts |   11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
>> index b396c83..bf6262f 100644
>> --- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
>> +++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
>> @@ -12,6 +12,14 @@
>>  					function = "gsbi1";
>>  				};
>>  			};
>> +
>> +			card_detect: card_detect {
>> +				mux {
>> +					pins = "gpio26";
>> +					function = "gpio";
>> +					bias-disable;
>> +				};
>> +			};
>>  		};
>>  
>>  		gsbi@12440000 {
>> @@ -49,6 +57,9 @@
>>  			/* External micro SD card */
>>  			sdcc3: sdcc@12180000 {
>>  				status = "okay";
>> +				pinctrl-names	= "default";
>> +				pinctrl-0	= <&card_detect>;
>> +				cd-gpios	= <&tlmm_pinmux 26 1>;

pls use the defines in gpio.h.

<&tlmm_pinmux 26 GPIO_ACTIVE_LOW>;

-- 
regards,
Stan
