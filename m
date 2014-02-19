Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaBSLlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:41:40 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59581 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaBSLlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:41:39 -0500
Date: Wed, 19 Feb 2014 11:41:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <monstr@monstr.eu>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, broonie@kernel.org
Subject: Re: [RFC PATCH v2 1/2] mfd: syscon: Support early initialization
Message-ID: <20140219114132.GC10504@lee--X1>
References: <cover.1392807832.git.michal.simek@xilinx.com>
 <fa3178534fcf4488fc45a9a24e44b2588acb38c6.1392807832.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa3178534fcf4488fc45a9a24e44b2588acb38c6.1392807832.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FAO Arnd, Mark,

> Some platforms need to get system controller
> ready as soon as possible.
> The patch provides early_syscon_initialization
> which create early mapping for all syscon compatible
> devices in early_syscon_probe.
> Regmap is get via syscon_early_regmap_lookup_by_phandle()
> 
> Regular device probes attach device to regmap
> via regmap_attach_dev().
> 
> For early syscon initialization is necessary to extend
> struct syscon and provide remove function
> which unmap all early init structures.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
> Changes in v2:
> - Fix bad logic in early_syscon_probe
> - Fix compilation failure for x86_64 reported by zero day testing system
> - Regmap change available here
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/nodev
> 
>  drivers/mfd/syscon.c       | 128 +++++++++++++++++++++++++++++++++++++++------
>  include/linux/mfd/syscon.h |  11 ++++
>  2 files changed, 122 insertions(+), 17 deletions(-)

I have the same reservations as last time:

  http://archive.arm.linux.org.uk/lurker/message/20140212.095424.96cb7281.html

I believe you were waiting for Arnd and/or Mark to comment.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
