Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965711AbaCSQJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:09:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53209 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965684AbaCSQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:09:28 -0400
Message-ID: <5329C133.60900@wwwdotorg.org>
Date: Wed, 19 Mar 2014 10:09:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Vince Hsu <vinceh@nvidia.com>
Subject: Re: [PATCH] mfd: as3722: make FUSE7_REG readable
References: <1393951832-2638-1-git-send-email-swarren@wwwdotorg.org> <20140305015539.GK10579@lee--X1>
In-Reply-To: <20140305015539.GK10579@lee--X1>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 06:55 PM, Lee Jones wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> The FUSE7_REG register is not currently marked readable. This causes
>> as3722_sd0_is_low_voltage() to emit an error during boot, and assume
>> the range of the SD0 regulator:
>>
>> as3722-regulator as3722-regulator: Reg 0xa7 read failed: -5
>>
>> Fixes: d4807ad2c4c0 ("regmap: Check readable regs in _regmap_read")
>> [exposed the bug, by checking for readability]
>> Fixes: 762a8ee80897 ("regulator: as3722: detect SD0 low-voltage mode")
>> [left out this register from the readable list]
>> Cc: Mark Brown <broonie@linaro.org>
>> Cc: Michal Simek <michal.simek@xilinx.com>
>> Cc: Andrew Bresticker <abrestic@chromium.org>
>> Cc: Vince Hsu <vinceh@nvidia.com>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> Note: I believe the regmap commit mentioned above is for 3.15, whereas
>> the as3722 commit is in at least 3.14. So, this only needs to be applied
>> for 3.15, but might make sense to go into earlier kernels, at your
>> discretion.
> 
> Applied to MFD -next (v3.15).

I don't see this in next-20140319; did it get dropped somewhere, or was
your branch not pushed out?
