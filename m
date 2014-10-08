Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaJHLRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:17:33 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:49154 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbaJHLRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:17:31 -0400
X-IronPort-AV: E=Sophos;i="5.04,677,1406617200"; 
   d="scan'208";a="47694657"
Message-ID: <54351D49.7040104@broadcom.com>
Date: Wed, 8 Oct 2014 04:17:29 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH 1/6] ARM: cygnus: Initial support for Broadcom Cygnus
 SoC
References: <sbranden@broadcom.com> <1412746025-11998-1-git-send-email-sbranden@broadcom.com> <1412746025-11998-2-git-send-email-sbranden@broadcom.com> <20141008081112.GB5182@n2100.arm.linux.org.uk>
In-Reply-To: <20141008081112.GB5182@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-08 01:11 AM, Russell King - ARM Linux wrote:
> On Tue, Oct 07, 2014 at 10:27:00PM -0700, Scott Branden wrote:
>> +static void __init bcm_cygnus_init(void)
>> +{
>> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>> +
>> +	l2x0_of_init(0, ~0UL);
>
> Please don't explicitly call l2x0 initialisation.  Instead, set the
> appropriate l2c members here:
>
>> +DT_MACHINE_START(BCM_CYGNUS_DT, "Broadcom Cygnus SoC")
>> +	.init_machine = bcm_cygnus_init,
>> +	.map_io = debug_ll_io_init,
>> +	.dt_compat = bcm_cygnus_dt_compat,
>> +	.restart   = bcm_cygnus_restart
>> +MACHINE_END
>
> and let the core code call it at the appropriate time.  Thanks.
>
Thanks - was unaware of this functionality.  Will add .l2c_aux_val and 
.l2c_aux mask to DT_MATCHINE_START.  BUT, what happens when we need to 
add trustzone support and make SMC call to secure monitor?

