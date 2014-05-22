Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaEVWGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:06:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38044 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaEVWGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:06:38 -0400
Message-ID: <537E74EC.1020004@codeaurora.org>
Date: Thu, 22 May 2014 18:06:36 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC] ARM: tty: Move HVC DCC assembly to arch/arm
References: <1382120064-2459-1-git-send-email-cov@codeaurora.org> <B273A106-344F-4D36-998B-E44F889AD93F@codeaurora.org>
In-Reply-To: <B273A106-344F-4D36-998B-E44F889AD93F@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

On 10/23/2013 01:59 AM, Kumar Gala wrote:
> 
> On Oct 18, 2013, at 1:14 PM, Christopher Covington wrote:
> 
>> Put architecture-specific assembly code where it belongs,
>> allowing for support of additional architectures such as arm64 in
>> the future.
>>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>> ---
>> arch/arm/include/asm/dcc.h | 45 +++++++++++++++++++++++++++++++++++++++++++
>> drivers/tty/hvc/hvc_dcc.c  | 48 ++--------------------------------------------
>> 2 files changed, 47 insertions(+), 46 deletions(-)
>> create mode 100644 arch/arm/include/asm/dcc.h
>>
>> diff --git a/arch/arm/include/asm/dcc.h b/arch/arm/include/asm/dcc.h
>> new file mode 100644
>> index 0000000..306d1fc
>> --- /dev/null
>> +++ b/arch/arm/include/asm/dcc.h
>> @@ -0,0 +1,45 @@
>> +/* Copyright (c) 2010, The Linux Foundation. All rights reserved.
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
>> +#include <asm/barrier.h>
>> +
>> +/* DCC Status Bits */
>> +#define DCC_STATUS_RX		(1 << 30)
>> +#define DCC_STATUS_TX		(1 << 29)
>> +
> 
> Why'd you move these define's here? They don't seem to be arch specific
> and I don't see them used in the asm anywhere.

Fixed in v2.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
