Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab3BSMTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:19:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44732 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab3BSMTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:19:39 -0500
Message-ID: <51236E11.1030900@ti.com>
Date: Tue, 19 Feb 2013 17:50:33 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Afzal Mohammed <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [PATCH, RFC 2/8] ARM: twd: register clock event for 1 core SMP
References: <cover.1361186097.git.afzal@ti.com> <a7f62b8580aa4b33d5658f4f03371a453adaea9b.1361186097.git.afzal@ti.com> <51235076.8040200@ti.com> <20130219121400.GP23197@arwen.pp.htv.fi>
In-Reply-To: <20130219121400.GP23197@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2013 05:44 PM, Felipe Balbi wrote:
> On Tue, Feb 19, 2013 at 03:44:14PM +0530, Santosh Shilimkar wrote:
>> On Monday 18 February 2013 05:07 PM, Afzal Mohammed wrote:
>>> Register percpu local timer for scheduler tick in the case of one core
>>> SMP configuration. In other cases - secondary cpu's as well as boot
>>> cpu's having more than one core, this is being registered as per
>>> existing boot flow, with a difference that they happens after delay
>>> calibration. Registering the clock for tick in case of one core should
>>> be done before Kernel calibrates delay (this is required to boot,
>>> unless local timer is the only one registered for tick). Registering
>>> twd local timer at init_time (which platforms are doing now) helps
>>> achieve that with the proposed change.
>>>
>>> This helps in an almost booting Kernel (minimal) by only relying on
>>> ARM parts for an A9 one core SMP.
>>>
>>> Signed-off-by: Afzal Mohammed <afzal@ti.com>
>>> ---
>> As mentioned in cover-letter, I don't think we have good
>> reasoning to make TWD to work with UP configuration. Even
>> you fix the timer code, there are more cascaded dependencies
>> which is not worth the effort.
>
> if CONFIG_SMP_ON_UP is enabled, smp_twd.c can still be compiled, right ?
>
Yep though just from deps pesrpective TWD is made available for ARM SMP
machines as below

config HAVE_ARM_TWD
         bool
         depends on SMP

Regards,
Santosh
