Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaFMQNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:13:38 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33736 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaFMQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:13:37 -0400
MIME-Version: 1.0
In-Reply-To: <CALAqxLWv2ALgsc+XTyZdJVyk0GYrxnx+UW10HGpiU8q5yVa_zg@mail.gmail.com>
References: <1402603992-12466-1-git-send-email-davidriley@chromium.org>
	<1402603992-12466-2-git-send-email-davidriley@chromium.org>
	<CALAqxLWv2ALgsc+XTyZdJVyk0GYrxnx+UW10HGpiU8q5yVa_zg@mail.gmail.com>
Date: Fri, 13 Jun 2014 09:13:35 -0700
Message-ID: <CAASgrz1KrgQZp6dN4Sp_1TwvPdtXQNXQim910bbs1VFnYC9z1w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] kernel: time: Add udelay_test module to validate udelay
From: David Riley <davidriley@google.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Doug Anderson <dianders@chromium.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 9:06 AM, John Stultz <john.stultz@linaro.org> wrote:
> On Thu, Jun 12, 2014 at 1:13 PM, David Riley <davidriley@chromium.org> wrote:
>> Create a module that allows udelay() to be executed to ensure that
>> it is delaying at least as long as requested (with a little bit of
>> error allowed).
>>
>> There are some configurations which don't have reliably udelay
>> due to using a loop delay with cpufreq changes which should use
>> a counter time based delay instead.  This test aims to identify
>> those configurations where timing is unreliable.
>>
>> Signed-off-by: David Riley <davidriley@chromium.org>
>> ---
>>  kernel/time/Kconfig       |   7 ++
>>  kernel/time/Makefile      |   1 +
>>  kernel/time/udelay_test.c | 170 ++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 178 insertions(+)
>>  create mode 100644 kernel/time/udelay_test.c
>>
>> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
>> index f448513..c6af048 100644
>> --- a/kernel/time/Kconfig
>> +++ b/kernel/time/Kconfig
>> @@ -202,3 +202,10 @@ config HIGH_RES_TIMERS
>>
>>  endmenu
>>  endif
>> +
>> +config UDELAY_TEST
>> +       tristate "udelay test driver"
>> +       default n
>> +       help
>> +         This builds the "udelay_test" module that helps to make sure
>> +         that udelay() is working properly.
>
>
> Thanks for resubmitting! So I've queued this for my testing.
>
> My only thoughts playing with it now, is that the Kconfig entry is
> just in an awkward spot. There isn't really a udelay, or really
> general timekeeping specific area in the menus, so it just shows up in
> "General Setup" between the "Timer Subsystem" and "Cpu/task time.."
> submenus.
>
> I suspect this would be better added in lib/Kconfig.debug near
> TEST_MODULE.  Any objections to me changing that?
>
> Also I'd probably rename the config option to TEST_UDELAY, as well as
> tweak the option string to be more consistent with those similar test
> driver options.

Hi John,

I'm okay with those changes.  Do you want me to resubmit or will you
just make the changes locally?

Thanks
Dave

>
> thanks
> -john
