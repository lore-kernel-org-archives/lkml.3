Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3EMQDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:03:19 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56271 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3EMQDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:03:18 -0400
Message-ID: <51910EC2.8090501@linaro.org>
Date: Mon, 13 May 2013 09:03:14 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Benoit Goby <benoit@android.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCHv2 2/2] PM: compile-time configuration of device suspend/resume
 watchdogs.
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org> <1368221329-1841-3-git-send-email-zoran.markovic@linaro.org> <CAMbhsRT2rc5A3zeKA2Om+y-Kv2HVh0pa6YjQ9BLC2jBBfWfxsA@mail.gmail.com>
In-Reply-To: <CAMbhsRT2rc5A3zeKA2Om+y-Kv2HVh0pa6YjQ9BLC2jBBfWfxsA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 11:23 PM, Colin Cross wrote:
> On Fri, May 10, 2013 at 2:28 PM, Zoran Markovic
> <zoran.markovic@linaro.org> wrote:
>> +#ifdef CONFIG_DPM_WD
>> +/**
>> + * dpm_wd_action - recovery from suspend/resume watchdog timeout
>> + * @wd: Watchdog. Must be allocated on the stack.
>> + */
>> +#if defined(CONFIG_DPM_WD_ACTION_STACKTRACE)
>> +static inline void dpm_wd_action(struct dpm_watchdog *wd)
>> +{
>> +       show_stack(wd->tsk, NULL);
>> +}
>> +#elif defined(CONFIG_DPM_WD_ACTION_PANIC)
>> +static inline void dpm_wd_action(struct dpm_watchdog *wd)
>> +{
>> +       panic("%s: unrecoverable failure\n", dev_name(wd->dev));
> The panic here is not very useful, it's going to print the stack of
> the task that was running when the timer fired which is likely to be
> the idle task if the suspend task is deadlocked.  This should call
> show_stack and panic.  If you take out the log action, then all this
> can stay inline with the handler and be:
>
> dev_emerg(wd->dev, "**** DPM device timeout ****\n");
> show_stack(wd->tsk, NULL);
> #ifdef CONFIG_DPM_WD_ACTION_PANIC
> panic("%s: unrecoverable failure\n", dev_name(wd->dev));
> #endif

#ifdefs in functions are usually to be avoided. Thus why I suggested he 
use the config dependent dpm_wd_action() function to handle this.

thanks
-john

