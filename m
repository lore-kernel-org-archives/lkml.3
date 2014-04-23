Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaDWKBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:01:37 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:57136 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaDWKBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:01:33 -0400
Date: Wed, 23 Apr 2014 11:01:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] mfd: syscon: Support early initialization
Message-ID: <20140423100127.GF21613@lee--X1>
References: <3eb785d83c406f4a57508dc03610b05492e12bfd.1396969250.git.michal.simek@xilinx.com>
 <53463824.3040606@samsung.com>
 <5346377C.1030606@monstr.eu>
 <53576B68.70602@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53576B68.70602@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> Some platforms need to get system controller
> >>> ready as soon as possible.
> >>> The patch provides early_syscon_initialization
> >>> which create early mapping for all syscon compatible
> >>> devices in early_syscon_probe.
> >>> Regmap is get via syscon_early_regmap_lookup_by_phandle()
> >>>
> >>> Regular device probes attach device to regmap
> >>> via regmap_attach_dev().
> >>>
> >>> For early syscon initialization is necessary to extend
> >>> struct syscon and provide remove function
> >>> which unmap all early init structures.
> >>>
> >>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> >>> ---
> >>>
> >>> Changes in v3:
> >>> - Keep backward compatibility for platform drivers and test it
> >>> - Use only one probe method which is early_syscon_probe
> >>>    suggested by Lee Jones. Do not force anybody to call early_syscon_init
> >>> - Add kernel-doc description
> >>>
> >>> Changes in v2:
> >>> - Fix bad logic in early_syscon_probe
> >>> - Fix compilation failure for x86_64 reported by zero day testing system
> >>> - Regmap change available here
> >>>    git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/nodev
> >>>
> >>>   drivers/mfd/syscon.c       | 159 ++++++++++++++++++++++++++++++++++++++++-----
> >>>   include/linux/mfd/syscon.h |  11 ++++
> >>>   2 files changed, 153 insertions(+), 17 deletions(-)

> Lee: Can you please look at these changes?  It is around for a while
> and I would like to close it. 

Actually I'm _still_ waiting on Arnd and Mark's opinion on this, as my
reservations from v1 still apply.

  https://lkml.org/lkml/2014/2/12/149

I'll poke them now.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
