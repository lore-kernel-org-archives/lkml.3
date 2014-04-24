Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbaDXOTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:19:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58512 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbaDXOS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:18:58 -0400
Message-ID: <53591D2E.8020505@ti.com>
Date: Thu, 24 Apr 2014 09:18:22 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Markus Pargmann <mpa@pengutronix.de>
Subject: Re: [RESEND PATCH] regulator: core: Disable unused regulators after
 deferred probing is done
References: <1398294650-24821-1-git-send-email-nm@ti.com> <20140424133451.GZ12304@sirena.org.uk>
In-Reply-To: <20140424133451.GZ12304@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 08:34 AM, Mark Brown wrote:
> On Wed, Apr 23, 2014 at 06:10:50PM -0500, Nishanth Menon wrote:
>> From: Saravana Kannan <skannan@codeaurora.org>
>>
>> regulator_init_complete does a scan of regulators which dont have
>> always-on or consumers are automatically disabled as being unused.
>> However, with deferred probing, late_initcall() is too soon to
>> declare a regulator as unused as the regulator itself might not
>> have registered due to defferal - Example: A regulator deffered due
>> to i2bus not available which in turn is deffered due to pinctrl
>> availability.
>>
>> Since deferred probing is done in late_initcall(), do the cleanup of
>> unused regulators by regulator_init_complete in late_initcall_sync
>> instead of late_initcall.
> 
> I'll apply this however since as we discussed on IRC last night it's
> going to make the issues with unconfigured regulators getting powered
> off more severe before I do so I'll change things so that regulators
> with no configuration at all don't get touched by the core.
> 
Thanks Mark.

-- 
Regards,
Nishanth Menon
