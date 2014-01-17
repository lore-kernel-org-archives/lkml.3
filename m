Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaAQQh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:37:57 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35434 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaAQQhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:37:52 -0500
Message-ID: <52D95C5E.4070209@linaro.org>
Date: Fri, 17 Jan 2014 17:37:50 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: Re: [PATCH 4/4] sched: Idle task shortcut optimization
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org> <1389949444-14821-4-git-send-email-daniel.lezcano@linaro.org> <20140117142644.GI11314@laptop.programming.kicks-ass.net> <52D94705.1000407@linaro.org> <20140117152310.GK11314@laptop.programming.kicks-ass.net> <52D94B95.2060704@linaro.org> <20140117153323.GM11314@laptop.programming.kicks-ass.net>
In-Reply-To: <20140117153323.GM11314@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 04:33 PM, Peter Zijlstra wrote:
> On Fri, Jan 17, 2014 at 04:26:13PM +0100, Daniel Lezcano wrote:
>>
>> Ah, ok. Let me try it.
>>
>
> http://programming.kicks-ass.net/sekrit/patches.tar.bz2
>
> has a queue that applies to tip/master.
>
> The patches as on lkml need a little help in applying.
>
> They've not been near a compiler yet though :/
>

Here are the results:

Col1 : tip/sched/core
Col2 : the patchset above
Col3 : the patchset above + idle task shortcut

hackbench -s 4096 -l 1000 -g 10 -f 40 -T
  33.306 32.720 31.902
  32.344	32.139 32.214
  33.342	33.281 33.056
  33.319	33.421 31.789
  32.325	32.540 31.941
  33.701	32.978 32.229
  34.981	32.418 30.218
  32.379	31.656 31.717
  32.135	32.241 32.812
  32.531	32.790 31.967

avg:
  33.036 32.618 31.984

hackbench -p -s 4096 -l 1000 -g 10 -f 40
  27.595 27.601 26.331
  25.192	29.336 30.222
  26.057	28.579 28.351
  28.397	29.419 28.554
  27.628	25.045 30.470
  28.976	28.027 29.823
  28.764	29.361 26.902
  27.632	30.101 26.285
  29.129	29.248 26.975
  26.020	25.047 29.324

avg:
  27.539 28.176 28.324

hackbench -P -s 4096 -l 1000 -g 10 -f 40
  32.788 32.057 30.691
  33.158	33.251 34.315
  32.713	33.076 32.880
  32.488	32.878 32.792
  31.240	33.003 32.958
  32.493	33.096 32.244
  33.940	33.660 31.550
  34.733	33.777 31.829
  32.598	34.117 33.714
  34.091	33.196 31.336
avg:
  33.024 33.211 32.431



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

