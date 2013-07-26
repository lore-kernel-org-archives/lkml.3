Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab3GZWEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:04:39 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:34383 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967Ab3GZWEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:04:35 -0400
Message-ID: <51F2F26E.4090909@gmail.com>
Date: Sat, 27 Jul 2013 00:04:30 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2] clk: exynos4: Add CLK_GET_RATE_NOCACHE flag for the
 Exynos4x12 ISP clocks
References: <1374786425-6697-1-git-send-email-sylvester.nawrocki@gmail.com> <20130726203026.7598.21711@quantum>
In-Reply-To: <20130726203026.7598.21711@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 10:30 PM, Mike Turquette wrote:
> Quoting Sylwester Nawrocki (2013-07-25 14:07:05)
>> From: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>
>> The ISP clock registers belong to the ISP power domain and may change
>> their values if this power domain is switched off/on. Add
>> CLK_GET_RATE_NOCACHE flags to ensure we do not rely on invalid cached
>> data when setting or getting frequency of those clocks.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>
> Thanks for the fix. I've taken into clk-fixes. Is there a specific
> regression this fixes (besides just having wrong clock rates). I can
> amend the changelog if you have an example (e.g. device X explodes).

Hmm, yes, this fixes a pretty serious problem. There is a companion
commit [1] already in Linus' tree, more details can be found there.

Perhaps something like this could be added:

"Otherwise the FIMC-IS Cortex-A5 core and AXI bus clocks have
incorrect frequencies, which breaks the ISP operation and starting
the video pipeline fails with timeouts reported by the FIMC-IS
firmware.

See related commit 722a860ecb29aa34ec6f7d7f32b949209e8
"[media] exynos4-is: Fix FIMC-IS clocks initialization" for more
details."

[1] 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit?id=722a860ecb29aa34ec6f7d7f32b949209e86a2f3

Thanks,
Sylwester
