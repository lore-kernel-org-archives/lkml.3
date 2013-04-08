Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936429Ab3DHKQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:16:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:64269 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935617Ab3DHKQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:16:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,429,1363158000"; 
   d="scan'208";a="315823422"
Date: Mon, 8 Apr 2013 12:16:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: mchehab@redhat.com, hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/9] mfd: Add commands abstraction layer for SI476X MFD
Message-ID: <20130408101624.GR24058@zurbaran>
References: <1364352446-28572-1-git-send-email-andrew.smirnov@gmail.com>
 <1364352446-28572-2-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364352446-28572-2-git-send-email-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Tue, Mar 26, 2013 at 07:47:18PM -0700, Andrey Smirnov wrote:
> From: Andrey Smirnov <andreysm@charmander.(none)>
> 
> This patch adds all the functions used for exchanging commands with
> the chip.
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> ---
>  drivers/mfd/si476x-cmd.c | 1554 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 1554 insertions(+)
>  create mode 100644 drivers/mfd/si476x-cmd.c
The patchset looks good to me, and I was willing to merge it but:


> diff --git a/drivers/mfd/si476x-cmd.c b/drivers/mfd/si476x-cmd.c
> new file mode 100644
> index 0000000..71ac2e8
> --- /dev/null
> +++ b/drivers/mfd/si476x-cmd.c
> @@ -0,0 +1,1554 @@
> +/*
> + * drivers/mfd/si476x-cmd.c -- Subroutines implementing command
> + * protocol of si476x series of chips
> + *
> + * Copyright (C) 2012 Innovative Converged Devices(ICD)
> + * Copyright (C) 2013 Andrey Smirnov
> + *
> + * Author: Andrey Smirnov <andrew.smirnov@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/completion.h>
> +#include <linux/delay.h>
> +#include <linux/atomic.h>
> +#include <linux/i2c.h>
> +#include <linux/device.h>
> +#include <linux/gpio.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/si476x.h>
This file doesn't exist yet, which breaks bisectability.
I'm fine with you including it with the first patch. I will prepare a branch
with the mfd patches from your serie for Mauro to pull from.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
