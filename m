Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3IZIZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:25:41 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:41483 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3IZIZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:25:39 -0400
Message-ID: <5243EF7F.4000606@linaro.org>
Date: Thu, 26 Sep 2013 10:25:35 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/21] cpuidle: don't calculate time-diff if entered_state
 == 0
References: <cover.1379779777.git.viresh.kumar@linaro.org>	<acd1cc837f969a50582d2b25a73c5e247f40f843.1379779777.git.viresh.kumar@linaro.org>	<524365FA.4090108@linaro.org> <CAKohpong15qzFg_sZVB77wVm4gu-4Se1E=eqvJOv96fgnyMXDA@mail.gmail.com>
In-Reply-To: <CAKohpong15qzFg_sZVB77wVm4gu-4Se1E=eqvJOv96fgnyMXDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 08:24 AM, Viresh Kumar wrote:
> On 26 September 2013 04:08, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> On 09/22/2013 03:21 AM, Viresh Kumar wrote:
>>> If entered_state == 0, we don't need to set dev->last_residency to 'diff' as we
>>> will be setting it to zero without using its new value.
>>
>> I don't get it, can you elaborate.
>
> Sure.. We have following code in cpuidle_enter_state():
>
> ---------
>          diff = ktime_to_us(ktime_sub(time_end, time_start));
>          if (diff > INT_MAX)
>                  diff = INT_MAX;
>
>          dev->last_residency = (int) diff;
>
>          if (entered_state >= 0) {
>                  /* Update cpuidle counters */
>                  /* This can be moved to within driver enter routine
>                   * but that results in multiple copies of same code.
>                   */
>                  dev->states_usage[entered_state].time += dev->last_residency;
>                  dev->states_usage[entered_state].usage++;
>          } else {
>                  dev->last_residency = 0;
>          }
> -------
>
> We are setting last_residency to 0 when (entered_state < 0) and aren't using
> the value of "diff". So, we can actually skip calculations of time_end, diff and
> last_residency when (entered_state < 0).. Makes sense?

Yes I agree, but why are you saying "If entered_state == 0, we don't 
need to ..." ?

>> We can be a long time in this state
>> (eg. if the prediction is false).
>
> Okay.. I didn't get it :)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

