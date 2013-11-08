Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab3KHSvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:51:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34032 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab3KHSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:51:39 -0500
Message-ID: <527D32BB.40607@codeaurora.org>
Date: Fri, 08 Nov 2013 10:51:39 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christopher Covington <cov@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
References: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org> <527D15E8.6070802@codeaurora.org>
In-Reply-To: <527D15E8.6070802@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/13 08:48, Christopher Covington wrote:
> Hi Stephen,
>
> On 11/07/2013 02:20 PM, Stephen Boyd wrote:
>> If we're running on a v7 ARM CPU, detect if the CPU supports the
>> sdiv/udiv instructions and replace the signed and unsigned
>> division library functions with an sdiv/udiv instruction.
> [...]
>
>> +++ b/arch/arm/lib/div-v7.c
>> @@ -0,0 +1,58 @@
>> +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/static_key.h>
>> +
>> +extern int ___aeabi_idiv(int, int);
>> +extern unsigned ___aeabi_uidiv(int, int);
> Why are the input parameters signed?

Copy pasta. Fixed thanks.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

