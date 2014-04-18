Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaDRMFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:05:14 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:53977 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaDRMFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:05:12 -0400
Message-ID: <535114F7.20307@linaro.org>
Date: Fri, 18 Apr 2014 07:05:11 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: bcm@fixthebug.org, mporter@linaro.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/10] ARM: bcm: tidy up a few includes
References: <1397788215-20279-1-git-send-email-elder@linaro.org> <1397788215-20279-8-git-send-email-elder@linaro.org> <20140418082936.GA24070@n2100.arm.linux.org.uk>
In-Reply-To: <20140418082936.GA24070@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 03:29 AM, Russell King - ARM Linux wrote:
> On Thu, Apr 17, 2014 at 09:30:12PM -0500, Alex Elder wrote:
>> Clean up a few header file includes, eliminating a few that are not
>> really needed and putting in their place some that are.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> Reviewed-by: Matt Porter <mporter@linaro.org>
>> ---
>>  arch/arm/mach-bcm/board_bcm21664.c |    3 +--
>>  arch/arm/mach-bcm/kona.c           |    5 +++--
>>  arch/arm/mach-bcm/kona.h           |    1 +
>>  3 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/mach-bcm/board_bcm21664.c b/arch/arm/mach-bcm/board_bcm21664.c
>> index acc1573..ab96c3f 100644
>> --- a/arch/arm/mach-bcm/board_bcm21664.c
>> +++ b/arch/arm/mach-bcm/board_bcm21664.c
>> @@ -11,13 +11,12 @@
>>   * GNU General Public License for more details.
>>   */
>>  
>> -#include <linux/clocksource.h>
>>  #include <linux/of_address.h>
>>  #include <linux/of_platform.h>
>>  
>>  #include <asm/mach/arch.h>
>> +#include <asm/io.h>
> 
> It's linux/io.h

Fixed, as you'll see when I post v2 later.

>> diff --git a/arch/arm/mach-bcm/kona.h b/arch/arm/mach-bcm/kona.h
>> index 110185f..bcdcf06 100644
>> --- a/arch/arm/mach-bcm/kona.h
>> +++ b/arch/arm/mach-bcm/kona.h
>> @@ -12,6 +12,7 @@
>>   */
>>  
>>  #ifdef CONFIG_ARCH_BCM_MOBILE_L2_CACHE
>> +#include <linux/init.h>
>>  
>>  void __init kona_l2_cache_init(void);
> 
> Just get rid of the __init instead.

Because __init is a "section" attribute, which affects
code and not the prototype.  That's great, thanks a lot.

					-Alex
