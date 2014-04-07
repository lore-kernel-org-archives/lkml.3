Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaDGPKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:10:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42835 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbaDGPKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:10:08 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v2] clk: qcom: Add support for IPQ8064's global clock controller (GCC)
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1396882918.28420.37.camel@iivanov-dev>
Date: Mon, 7 Apr 2014 10:10:02 -0500
Cc: Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        sboyd@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AF6AA9C9-6A47-4394-91FD-F7F0C264C530@codeaurora.org>
References: <1396642749-12979-1-git-send-email-galak@codeaurora.org> <1396882918.28420.37.camel@iivanov-dev>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 7, 2014, at 10:01 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:

> Hi Kumar,
> 
> On Fri, 2014-04-04 at 15:19 -0500, Kumar Gala wrote:
>> Add a driver for the global clock controller found on IPQ8064 based
>> platforms. This should allow most non-multimedia device drivers to probe
>> and control their clocks.
>> 
>> This is currently missing clocks for SATA, USB, and networking devices.
>> 
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> v2:
>> * dropped audio clock from commit message
>> * changed Kconfig symbol to IPQ_GCC_806X
>> * Fixed PXO/CXO clk freq to 25Mhz
>> 
> 
> <snip>
> 
>> --- /dev/null
>> +++ b/drivers/clk/qcom/gcc-ipq806x.c
>> @@ -0,0 +1,1957 @@
>> +/*
>> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/bitops.h>
>> +#include <linux/err.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/regmap.h>
>> +#include <linux/reset-controller.h>
>> +
>> +#include <dt-bindings/clock/qcom,gcc-ipq806x.h>
>> +#include <dt-bindings/reset/qcom,gcc-ipq806x.h>
>> +
>> +#include "common.h"
> 
> Do I miss something or this file is not available?

Its based on Stephen’s refactoring patch:

https://patchwork.kernel.org/patch/3876761/

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

