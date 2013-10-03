Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3JCLqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:46:38 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:57995 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3JCLqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:46:37 -0400
Message-ID: <524D5919.5060103@linaro.org>
Date: Thu, 03 Oct 2013 13:46:33 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/21] cpuidle: don't call poll_idle_init() for every
 cpu
References: <cover.1379779777.git.viresh.kumar@linaro.org>	<495ffb1175175b0180ca3da96eb5ed72a8280364.1379779777.git.viresh.kumar@linaro.org>	<52436237.3040500@linaro.org>	<CAKohpokBPD35pBpCt-x0KGNvy3hxmYGPxXpSBJZcgo7ir8L3hA@mail.gmail.com>	<5243F02B.2030302@linaro.org> <CAKohponH-oEagm9E2r+XLRJpY7rgmjjoJjcQHtMpMckDW_q8VQ@mail.gmail.com>
In-Reply-To: <CAKohponH-oEagm9E2r+XLRJpY7rgmjjoJjcQHtMpMckDW_q8VQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 12:33 PM, Viresh Kumar wrote:
> On 26 September 2013 13:58, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> Yes, certainly and that will impact also the menu select governor function:
>>
>>   ...
>>
>>          /*
>>           * We want to default to C1 (hlt), not to busy polling
>>           * unless the timer is happening really really soon.
>>           */
>>          if (data->expected_us > 5 &&
>>              !drv->states[CPUIDLE_DRIVER_STATE_START].disabled &&
>>                  dev->states_usage[CPUIDLE_DRIVER_STATE_START].disable == 0)
>>                  data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
>>
>>          /*
>>           * Find the idle state with the lowest power while satisfying
>>           * our constraints.
>>           */
>>          for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
>>                  struct cpuidle_state *s = &drv->states[i];
>>                  struct cpuidle_state_usage *su = &dev->states_usage[i];
>>
>>                  if (s->disabled || su->disable)
>>                          continue;
>>                  if (s->target_residency > data->predicted_us)
>>                          continue;
>>                  if (s->exit_latency > latency_req)
>>                          continue;
>>                  if (s->exit_latency * multiplier > data->predicted_us)
>>                          continue;
>>
>>                  data->last_state_idx = i;
>>                  data->exit_us = s->exit_latency;
>>          }
>
> Hmm.. For now I will repost this patch as is and then you can go ahead
> for this bigger change.. I wouldn't be able to do this change now, as I
> would be rushing for my 2 weeks vacations :)
>
> If this patch looked okay to you, can you please Ack it ?

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

