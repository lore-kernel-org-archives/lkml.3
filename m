Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaFMPGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:06:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50244 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaFMPGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:06:41 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-2c-539b137fefa7
Message-id: <539B137D.4060408@samsung.com>
Date: Fri, 13 Jun 2014 17:06:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Tero Kristo <t-kristo@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, sw0312.kim@samsung.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v5 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1397042790-10636-1-git-send-email-s.nawrocki@samsung.com>
 <1397042790-10636-3-git-send-email-s.nawrocki@samsung.com>
 <CAL_JsqKDJ_yFxFYnrTtmzMPoxO2rmypiujybwbhUh35y1LS-Mw@mail.gmail.com>
 <5347DF4D.5000005@samsung.com> <20140523013406.9521.82891@quantum>
 <537EECC7.2030605@ti.com>
In-reply-to: <537EECC7.2030605@ti.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02RXUhTYRiA+c7O+XY2XH5NjQ8xpYFakn9l+REhdSOnO8GISCTnXCo4lR0n
	mhcOTVJxczk1m6mVepHOjE2dlmaYf5CKMrQfUwRdZZlGxTJQydO68O7h4Xnf9+JlRfJO2p/N
	zM5Ta7OVWQoopV/vTcyHF/s0JkY97gsgK+/LKNIyOsOQ6o2HDHm50w9IaWs3JNMlG2JScadN
	TGyrCwxxPrsPyaJTRrpGl8Sk/c0cRVymOUhquuoAKRsaFZPfbjckuw4bTRrM65C0ucoh6W74
	Sl/w5azNVsDdKq2CnNNooLiP62aKG7AsibnG8nsMZ+uogNyHhUHIDTdZxZy9rZgzlG5Crno3
	ijP2dABu4q2D4n7aAhO8r0nPp6mzMvPV2si4FGlGj34c5m56F/SZLFAPFrwqgYTFKAZ3uQcZ
	Dx/Bs8vdUGA5agd4y3XZwz8Adpb9a2QoDFc5W/YblqVRMDbP5gkaomhsGDMCQfuhq3h1Vu6p
	D+Nt8zItsC86hvXlz/e3SFkR2oDYWuKghd4HJWFbr07wctRJ4VdTa5QwIEEheMk1JhJYhEJx
	TfOj/xyE7dZvIhNAlgM3LAcyy4HsARB1AD+1TpXLp6ZroiN4pYbXZadHqHI0NuB58K9+0Dp+
	bgQgFii8ZN+LLIlyRpnPF2pGAGZFCl/Zsn5fydKUhTfV2pzrWl2Wmh8BFCvx1wOTOGQlGJ4y
	MoVrd8+ghGHdTmDM0BWFLm7azhr2QhNPLB4ll2Lhi8gChyvc7ZXyea6ytrfu0IyqKUhmD1gZ
	f8LE18feyNlLPgmnTxdt2fJ6zs6rJGFJqQPhlqmInciJTyn24/XxO66LT/k/yV8ctZO3t6uZ
	SZTs9p5C74bTFTSfoYwOE2l55V+7oaenvgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/14 08:37, Tero Kristo wrote:
> On 05/23/2014 04:34 AM, Mike Turquette wrote:
[...]
>> It looks like this idea was dropped for v6. Can we revisit it? Take a
>> look at Tero's example implementation for OMAP using this binding:
>>
>> http://www.spinics.net/lists/linux-omap/msg104705.html
>>
>> There is a bogus "default-clocks" node made solely for storing this info
>> within the OMAP PRCM clock provider node. This is basically faking a
>> clock consumer. I think with the proposed solution above Tero could have
>> avoided that node entirely and done the following:
>>
>> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
>> index 649b5cd..e3ff1a7 100644
>> --- a/arch/arm/boot/dts/omap4.dtsi
>> +++ b/arch/arm/boot/dts/omap4.dtsi
>> @@ -145,6 +145,11 @@
>>   			cm2_clocks: clocks {
>>   				#address-cells = <1>;
>>   				#size-cells = <0>;
>> +
>> +				assigned-clocks = <&abe_dpll_refclk_mux_ck>,
>> +					<&dpll_usb_ck>, <&dpll_abe_ck>;
>> +				assigned-clock-parents = <&sys_32k_ck>;
>> +				assigned-clock-rates = <0>, <960000000>, <98304000>;
>>   			};
>>
>>   			cm2_clockdomains: clockdomains {
>>
>>
>> Tero, what do you think?
> 
> Yeah, if we can avoid having a dummy node someplace, it is always 
> better. Only issue might be the initialization order, this was the 
> reason I created the dummy node if I recall right. But I guess we can 
> just scan the clock provider nodes second time at a later phase of boot 
> (or just store the default info for later use.)

One issue I'm a bit concerned about with an initcall-like approach is
it may not work well for clock providers in kernel modules which can be
loaded at any time.  So doing the configuration upon the clock provider
registration might have worked better.  Then we could disallow (defer)
a clock provider registration if any of its dependencies (as specified
through assigned-clock* properties) are not satisfied.  Do you think
that could work ?

--
Thanks,
Sylwester
