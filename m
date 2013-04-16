Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3DPIQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:16:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33484 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab3DPIQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:16:35 -0400
Message-ID: <516D08C0.70702@ti.com>
Date: Tue, 16 Apr 2013 10:16:00 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130408 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@iki.fi>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH] RTC: rtc-twl: Convert to module_platform_driver() and
 relocate reg_map init
References: <1366098262-20726-1-git-send-email-peter.ujfalusi@ti.com> <516D0790.7090902@iki.fi>
In-Reply-To: <516D0790.7090902@iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On 04/16/2013 10:10 AM, Tomi Valkeinen wrote:
> Hi,
> 
> On 2013-04-16 10:44, Peter Ujfalusi wrote:
>> Convert the driver to use module_platform_driver() to register the platform
>> driver and relocate the rtc_reg_map initialization to platform driver's
>> probe function.
>> In this way we can make sure that the twl-core has been already probed since
>> the core driver will create the device at the end of it's probe function.
>>
>> Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> I think there are two distinct things here. The actual fix for the
> regmap, and a module_platform_driver cleanup. I would suggest having
> them in separate patches.
> 
> And even if these are combined, I think the patch subject and
> description should talk about fixing the regmap bug. Now it's rather
> unclear that an actual bug is being fixed.

Good point. My thinking was that when I convert the driver to
module_platform_driver() the reg map init must be moved to platform_driver's
probe anyways.
I'll separate the patch and write a bit better commit message for the first.

-- 
Péter
