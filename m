Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3HPPmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:42:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40609 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3HPPmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:42:32 -0400
Message-ID: <520E482A.1070504@ti.com>
Date: Fri, 16 Aug 2013 21:11:30 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Benoit Cousson <bcousson@baylibre.com>
CC: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>, <mark.rutland@arm.com>,
        <a.zummo@towertech.it>,
        <davinci-linux-open-source@linux.davincidsp.com>, <khilman@linaro.org>,
        <rtc-linux@googlegroups.com>, <devicetree@vger.kernel.org>,
        <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <rob.herring@calxeda.com>, <sudhakar.raj@ti.com>, <rob@landley.net>,
        <grant.likely@linaro.org>, <akpm@linux-foundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/2] rtc: omap: update of_device_id to reflect latest
 ip revisions
References: <1376653017-21935-1-git-send-email-gururaja.hebbar@ti.com> <1376653017-21935-2-git-send-email-gururaja.hebbar@ti.com> <520E341D.4080206@baylibre.com>
In-Reply-To: <520E341D.4080206@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 8/16/2013 7:45 PM, Benoit Cousson wrote:
> Hi Gururaja,
> 
> On 16/08/2013 13:36, Hebbar, Gururaja wrote:
>> The syntax of compatible property in DT is to mention the Most specific
>> match to most generic match.
>>
>> Since AM335x is the platform with latest IP revision, add it 1st in
>> the device id table.
> 
> I don't understand why? The order should not matter at all.

Yes, it should not. We are trying to work around a bug in the kernel
where the compatible order is not honored (instead the order in
of_match[] array matters). There were patches being discussed to fix this.

> 
> I've tried to follow the thread you had with Mark on the v2, but AFAIK,
> you've never answered to his latest question.
> 
> Moreover, checking the differences between the Davinci and the am3352
> RTC IP, I would not claim that both are compatible.
> 
> Sure you can use the am3352 with the Davinci driver, but you will lose
> the wakeup functionality without even being notify about that.

When the kernel is fixed for the bug pointed out above, this should not
happen with properly defined compatible property.

> 
> For my point of view, compatible mean that the HW will still be fully
> functional with both versions of the driver, which is not the case here.

I do not think that's the interpretation of compatible. Its goes from
most specific to most generic per the ePAPR spec. That in itself says
that 100% functionality is not expected if you don't find a match for
the more specific property.

> 
> am3352 DTS must use the ti,am3352-rtc to have the expected behavior.

Yes, that's what patch 2/2 does.

> Using the ti,da830-rtc version will not make the board working as
> expected. So we cannot claim the compatibility.

Ideally, the DT file was *always* written as

	compatible = "ti,am3352-rtc", "ti,da830-rtc";

even when there was no kernel support for AM3352 RTC.

That way, there is no need to update the .dts[i] file. As kernel gains
functionality, more features (like rtc wake) is available to users.
Otherwise they get plain RTC functionality - but at least they get
something instead of no RTC.

Thanks,
Sekhar
