Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaAHLLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:11:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34040 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbaAHLLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:11:48 -0500
Message-ID: <52CD324D.3020701@ti.com>
Date: Wed, 8 Jan 2014 16:41:09 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Sebastian Reichel <sre@debian.org>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding information
References: <1389161742-10533-1-git-send-email-rogerq@ti.com> <52CD23E0.8030400@ti.com> <20140108105244.GA21607@earth.universe> <3761842.HRY1CDBF4z@wuerfel>
In-Reply-To: <3761842.HRY1CDBF4z@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 04:25 PM, Arnd Bergmann wrote:
> On Wednesday 08 January 2014 11:52:44 Sebastian Reichel wrote:
>>
>> On Wed, Jan 08, 2014 at 03:39:36PM +0530, Roger Quadros wrote:
>>>> What about the other clocks acquired in drivers/mfd/omap-usb-host.c? Shouldn't
>>>> all of those be provided by via the DT phandle?
>>>
>>> All those clocks are identically named across the OMAP SoCs and are unique for each
>>> SoC, so providing DT phandle for all of them is not required.
>>>
>>> The init_60m_fclk was renamed to l3init_60m_fclk in OMAP5, and hence the need for
>>> this binding.
>>
>> I understand the intention of this patch. I was just wondering if
>> all the clocks should be referenced from DT even if that is not
>> strictly needed at the moment. This would make clocks similar to
>> other resources like regulators, gpios, irqs, ...
>>
>> Having the clocks referenced from DT looks cleaner to me. It means I
>> can check the DT file for any resources used by a driver. It also
>> creates some kind of consistency in the kernel.
> 
> I think that would be best, yes. AFAIK most other platforms do this
> already, OMAP is a bit behind because it started using clocks when the
> infrastructure for doing this right was still incomplete.
> 

OK. I'll update the binding information to reflect all the clocks.

But what about clk_get() vs of_clk_get_by_name() ?

cheers,
-roger
