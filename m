Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab3GQVHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:07:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:3559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab3GQVHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:07:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,687,1367996400"; 
   d="scan'208";a="366900557"
Date: Wed, 17 Jul 2013 23:07:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Olof Johansson <olof@lixom.net>,
        Pawel Moll <pawel.moll@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v5 0/1] drivers: mfd: Versatile Express SPC support
Message-ID: <20130717210700.GA19864@zurbaran>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lorenzo,

On Tue, Jul 16, 2013 at 05:05:42PM +0100, Lorenzo Pieralisi wrote:
> Hello,
> 
> version v5 of VExpress SPC driver, please read on the changelog for major
> changes and explanations.
> 
> The probing scheme is unchanged, since after trying the early platform
> devices approach it appeared that the end result was no better than the
> current one. The only clean solution relies either on changing how
> secondaries are brought up in the kernel (later than now) or enable
> early platform device registration through DT. Please check this
> thread for the related discussion:
> 
> https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/036542.html
> 
> The interface was adapted to regmap and again reverted to old driver for
> the following reasons:
> 
> - Power down registers locking is hairy and requires arch spinlocks in
>   the MCPM back end to work properly, normal spinlocks cannot be used
> - Regmap adds unnecessary code to manage SPC since it is just a bunch of
>   registers used to control power management flags, the overhead is just
>   not worth it (talking about power down registers, not the vexpress config
>   interface)
> - The locking scheme behind regmap requires all registers in the map
>   to be protected with the same lock, which is not exactly what we want
>   here
> - Given the reasons above, adding a regmap interface buys us nothing from
>   a driver readability and maintainability perspective (again just talking
>   about the power interface, a few registers) because for the SPC it would
>   simply not be used
> 
> /drivers/mfd is probably not the right place for this code as it stands (but
> probably will be when the entire driver, with DVFS and config interface, is
> complete).
Could you please elaborate on how will the SPC driver extend into an MFD
driver?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
