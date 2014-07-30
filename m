Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaG3WlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:41:04 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35024 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaG3WlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:41:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Greg KH" <greg@kroah.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140730185708.12a99f00@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>,
        "Kim Phillips" <kim.phillips@freescale.com>
References: <20140730185708.12a99f00@canb.auug.org.au>
Message-ID: <20140730224056.11617.36256@quantum>
User-Agent: alot/0.3.5
Subject: Re: linux-next: manual merge of the clk tree with the driver-core tree
Date: Wed, 30 Jul 2014 15:40:56 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Rothwell (2014-07-30 01:57:08)
> Hi Mike,
> 
> Today's linux-next merge of the clk tree got a conflict in
> drivers/base/platform.c between commit 3d713e0e382e ("driver core:
> platform: add device binding path 'driver_override'") from the
> driver-core tree and commit 86be408bfbd8 ("clk: Support for clock
> parents and rates assigned from device tree") from the clk tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me.

Thanks,
Mike

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/base/platform.c
> index 7cc7440b014d,ac47643b1b69..000000000000
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@@ -23,7 -23,7 +23,8 @@@
>   #include <linux/pm_runtime.h>
>   #include <linux/idr.h>
>   #include <linux/acpi.h>
>  +#include <linux/limits.h>
> + #include <linux/clk/clk-conf.h>
>   
>   #include "base.h"
>   #include "power/power.h"
