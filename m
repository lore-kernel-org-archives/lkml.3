Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab3FABbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 21:31:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40911 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3FABay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 21:30:54 -0400
Message-ID: <51A94ECC.5090303@codeaurora.org>
Date: Fri, 31 May 2013 18:30:52 -0700
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH] arm: Prevent memory aliasing on non-LPAE kernels
References: <1369950320-22784-1-git-send-email-stepanm@codeaurora.org> <3054064.aJsgTxiNUL@wuerfel>
In-Reply-To: <3054064.aJsgTxiNUL@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/2013 3:24 PM, Arnd Bergmann wrote:
>> +       if (size > ((phys_addr_t)~0))
>> +               size = ((phys_addr_t)~0);
>> +
>> +       /* arm_add_memory() already checks for the case of base + size > 4GB */
>> +#endif
>>          arm_add_memory(base, size);
>>   }
>
> This looks wrong for the case where 'base' is between >0 and 4GB and 'size'
> makes it spill over the 4GB boundary. You need to set
> 'size = (phys_addr_t)~0 - base' then.
>

Ah. I believe arm_add_memory() already has the logic to handle this 
case. Here, we are just trying to shrink 'size' to fit into phys_addr_t, 
since it is currently u64 but arm_add_memory() uses phys_addr_t for its 
arguments. I did not want to have this logic in two places, but I can do 
what you said if you like.


-- 
  The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
  hosted by The Linux Foundation
