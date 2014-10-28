Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487AbaJ1HBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:01:36 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64038 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445AbaJ1HBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:01:33 -0400
MIME-Version: 1.0
In-Reply-To: <1414054881-17713-3-git-send-email-daniel.lezcano@linaro.org>
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org>
	<1414054881-17713-3-git-send-email-daniel.lezcano@linaro.org>
Date: Tue, 28 Oct 2014 12:31:33 +0530
Message-ID: <CAM4v1pO9e7r10KX=D=9aVTV_ecvPa-aJOoB6PAwR5jxMS3eg4w@mail.gmail.com>
Subject: Re: [PATCH V2 3/5] cpuidle: idle: menu: Don't reflect when a state
 selection failed
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        patches@linaro.org, Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 2:31 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> In the current code, the check to reflect or not the outcoming state is done
> against the idle state which has been chosen and its value.
>
> Instead of doing a check in each of the reflect functions, just don't call reflect
> if something went wrong in the idle path.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> ---
>  drivers/cpuidle/governors/ladder.c | 3 +--
>  drivers/cpuidle/governors/menu.c   | 4 +---
>  kernel/sched/idle.c                | 3 ++-
>  3 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
> index fb396d6..c0b36a8 100644
> --- a/drivers/cpuidle/governors/ladder.c
> +++ b/drivers/cpuidle/governors/ladder.c
> @@ -165,8 +165,7 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
>  static void ladder_reflect(struct cpuidle_device *dev, int index)
>  {
>         struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
> -       if (index > 0)
> -               ldev->last_state_idx = index;
> +       ldev->last_state_idx = index;
>  }
>
>  static struct cpuidle_governor ladder_governor = {
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index a17515f..3907301 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -365,9 +365,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
>  static void menu_reflect(struct cpuidle_device *dev, int index)
>  {
>         struct menu_device *data = &__get_cpu_var(menu_devices);
> -       data->last_state_idx = index;
> -       if (index >= 0)
> -               data->needs_update = 1;
> +       data->needs_update = 1;

Why is the last_state_idx not getting updated ?

Regards
Preeti U Murthy
