Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaDDHwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:52:35 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:45679 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaDDHw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:52:28 -0400
MIME-Version: 1.0
In-Reply-To: <533E635F.9050803@intel.com>
References: <20140404031928.GC11828@localhost>
	<CAKohponbGFFo+W7X24e4h3ub2L8Tkb89eP6_F17CRYELk0yeRQ@mail.gmail.com>
	<533E635F.9050803@intel.com>
Date: Fri, 4 Apr 2014 13:22:28 +0530
Message-ID: <CAKohpon+THY2NXEEOcWRbmrpfQUZYbHfO+Lw=D9TaJWk+_-J2g@mail.gmail.com>
Subject: Re: WARNING: CPU: 0 PID: 1935 at kernel/timer.c:1621 migrate_timer_list()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 April 2014 13:16, Jet Chen <jet.chen@intel.com> wrote:
> Hi Viresh,
>
> I changed your print message as you suggested.
>
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 6c3a371..193101d 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1617,8 +1617,8 @@ static void migrate_timer_list(struct tvec_base
> *new_base, struct list_head *hea
>
>                  /* Check if CPU still has pinned timers */
>                  if (unlikely(WARN(is_pinned,
> -                                 "%s: can't migrate pinned timer: %p,
> deactivating it\n",
> -                                 __func__, timer)))
> +                                 "%s: can't migrate pinned timer: %p,
> timer->function: %p,deactivating it\n",
> +                                 __func__, timer, timer->function)))
>                          continue;
>
> Then I reproduced the issue, and got the dmesg output,
>
> [   37.918406] migrate_timer_list: can't migrate pinned timer:
> ffffffff81f06a60, timer->function: ffffffff810d7010,deactivating it
>
> We reproduced this issue for several times in our LKP system. The address of
> timer ffffffff81f06a60 is very constant. So is timer->function, I believe.
>
> Hope this information will help you. Please feel free to tell me what else I
> can do to help you.

Hi Jet,

Thanks a lot. Yes that's pretty helpful.. But I need some more help from you..
I don't have any idea which function has this address in your kernel:
ffffffff810d7010 :)

Can you please debug that a bit more? You need to find which function
this address belongs to. You can try that using objdump on your vmlinux.

Some help can be found here: Documentation/BUG-HUNTING

Thanks in Advance.
