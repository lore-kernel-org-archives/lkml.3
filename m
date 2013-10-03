Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3JCKdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:33:45 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:56429 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab3JCKdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:33:43 -0400
MIME-Version: 1.0
In-Reply-To: <5243F02B.2030302@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<495ffb1175175b0180ca3da96eb5ed72a8280364.1379779777.git.viresh.kumar@linaro.org>
	<52436237.3040500@linaro.org>
	<CAKohpokBPD35pBpCt-x0KGNvy3hxmYGPxXpSBJZcgo7ir8L3hA@mail.gmail.com>
	<5243F02B.2030302@linaro.org>
Date: Thu, 3 Oct 2013 16:03:42 +0530
Message-ID: <CAKohponH-oEagm9E2r+XLRJpY7rgmjjoJjcQHtMpMckDW_q8VQ@mail.gmail.com>
Subject: Re: [PATCH 18/21] cpuidle: don't call poll_idle_init() for every cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 13:58, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> Yes, certainly and that will impact also the menu select governor function:
>
>  ...
>
>         /*
>          * We want to default to C1 (hlt), not to busy polling
>          * unless the timer is happening really really soon.
>          */
>         if (data->expected_us > 5 &&
>             !drv->states[CPUIDLE_DRIVER_STATE_START].disabled &&
>                 dev->states_usage[CPUIDLE_DRIVER_STATE_START].disable == 0)
>                 data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
>
>         /*
>          * Find the idle state with the lowest power while satisfying
>          * our constraints.
>          */
>         for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
>                 struct cpuidle_state *s = &drv->states[i];
>                 struct cpuidle_state_usage *su = &dev->states_usage[i];
>
>                 if (s->disabled || su->disable)
>                         continue;
>                 if (s->target_residency > data->predicted_us)
>                         continue;
>                 if (s->exit_latency > latency_req)
>                         continue;
>                 if (s->exit_latency * multiplier > data->predicted_us)
>                         continue;
>
>                 data->last_state_idx = i;
>                 data->exit_us = s->exit_latency;
>         }

Hmm.. For now I will repost this patch as is and then you can go ahead
for this bigger change.. I wouldn't be able to do this change now, as I
would be rushing for my 2 weeks vacations :)

If this patch looked okay to you, can you please Ack it ?
