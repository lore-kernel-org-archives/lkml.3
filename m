Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab3GRGpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:45:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49133 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3GRGpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:45:08 -0400
Message-ID: <51E78ED4.2020107@ti.com>
Date: Thu, 18 Jul 2013 09:44:36 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 0/3] ARM: OMAP2+: omap_device: add dynamic pinctrl handling
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com> <51E686C1.8020801@ti.com> <51E68E6C.60100@ti.com>
In-Reply-To: <51E68E6C.60100@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 03:30 PM, Grygorii Strashko wrote:
> On 07/17/2013 02:57 PM, Roger Quadros wrote:
>> Hi Grygorii,
>>
>> On 07/17/2013 02:41 PM, Grygorii Strashko wrote:
>>> Hi Tony, Kevin
>>>
>>> This patch series introduces dynamic pinctrl handling in OMAP device framework
>>> in the same way as it was before switching to DT.
>>> This allow OMAP devices driver's developers to simply add dynamic pinctrl
>>> handling for "default", "active", "idle", "sleep" PIN states in their drivers
>>> by modifying DT definitions only - no modifications in drivers code are not needed.
>>>
>>
>> Overall I like the idea but can we make a provision for device drivers to override
>> this default pin state handling?
>>
>> The OMAP EHCI driver is one such special case where the wakeup mechanism is tied to pinctrl states
>> as it uses IO daisy chaining to implement wakeup.
>> So depending on whether wakeup needs to be enabled or not I must be able to chose whether
>> I put the pin in just "sleep" state or "sleep with wakeup" state.
> 
> I think, in this case you can't use default behavior and need to define
> custom pins states like "sleep_wakeup"/"sleep_no_wakeup" and do not
> define pins state with name "sleep', so Device core and OMAP device
> framework will not touch your pins.

Yes, I think this should be fine. Thanks.

cheers,
-roger
