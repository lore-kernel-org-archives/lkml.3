Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaF3LBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:01:37 -0400
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:41681 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaF3LBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:01:36 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2014 07:01:35 EDT
Message-ID: <53B14386.1040706@de.bosch.com>
Date: Mon, 30 Jun 2014 13:01:26 +0200
From: Dirk Behme <dirk.behme@de.bosch.com>
Organization: Robert Bosch Car Multimedia GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <mathieu.poirier@linaro.org>
CC: <linus.walleij@linaro.org>, <will.deacon@arm.com>,
        <linux@arm.linux.org.uk>, <daniel.thompson@linaro.org>,
        <robherring2@gmail.com>, <robbelibobban@gmail.com>, <Al.Grant@arm.com>,
        <patches@linaro.org>, <marcin.jabrzyk@gmail.com>,
        <linux-kernel@vger.kernel.org>, <arnd@linaro.org>,
        <panchaxari.prasannamurthy@linaro.org>, <r.sengupta@samsung.com>,
        <arve@android.com>, <Tony.Armitstead@arm.com>,
        <john.stultz@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <james.king@linaro.org>, <pratikp@codeaurora.org>, <varshney@ti.com>,
        <jonas.svennebring@avagotech.com>
Subject: Re: [PATCH 6/9 v2] coresight-etm: add CoreSight ETM/PTM driver
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org> <1403892261-25026-7-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1403892261-25026-7-git-send-email-mathieu.poirier@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.211.33]
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.06.2014 20:04, mathieu.poirier@linaro.org wrote:
> From: Pratik Patel <pratikp@codeaurora.org>
>
> This driver manages CoreSight ETM (Embedded Trace Macrocell) that
> supports processor tracing. Currently supported version are ARM
> ETMv3.3, v3.5 and PTM.
>
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>   arch/arm/include/asm/hardware/cp14.h   |  540 ++++++++++++
>   drivers/coresight/Kconfig              |   19 +
>   drivers/coresight/Makefile             |    1 +
>   drivers/coresight/coresight-etm-cp14.c |  506 +++++++++++
>   drivers/coresight/coresight-etm.c      | 1507 ++++++++++++++++++++++++++++++++
>   drivers/coresight/coresight-etm.h      |  192 ++++
>   6 files changed, 2765 insertions(+)
>   create mode 100644 arch/arm/include/asm/hardware/cp14.h
>   create mode 100644 drivers/coresight/coresight-etm-cp14.c
>   create mode 100644 drivers/coresight/coresight-etm.c
>   create mode 100644 drivers/coresight/coresight-etm.h
....
> diff --git a/drivers/coresight/coresight-etm-cp14.c b/drivers/coresight/coresight-etm-cp14.c
> new file mode 100644
> index 0000000..4173710
> --- /dev/null
> +++ b/drivers/coresight/coresight-etm-cp14.c
> @@ -0,0 +1,506 @@
> +/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/bug.h>
> +#include <asm/hardware/cp14.h>
> +
> +#include <coresight-etm.h>

As coresight-etm.h is in drivers/coresight I had to use

-#include <coresight-etm.h>
+#include "coresight-etm.h"

Not sure if this somehow depends on the kernel version/tooling, though.

Best regards

Dirk

