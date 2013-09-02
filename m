Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab3IBPv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:51:56 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:37133 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758760Ab3IBPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:51:55 -0400
Message-ID: <5224B3F5.8090402@gmail.com>
Date: Mon, 02 Sep 2013 17:51:17 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Max Filippov <jcmvbkbc@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.10.9: kmemleak disables all CPUs except CPU0
References: <5221F119.4070000@gmail.com> <CAHkRjk4g4-ig1zyX7qYO2byVhQQK0kZ4rgRCWU141hd-3c3==w@mail.gmail.com> <CAMo8BfLMex3H1QBk6gD7DDDgGJ4dh6+dvhLG=c7LdFZ8XuyM9Q@mail.gmail.com> <20130902154840.GC13871@arm.com>
In-Reply-To: <20130902154840.GC13871@arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Catalin Marinas wrote:
> On Mon, Sep 02, 2013 at 04:44:52PM +0100, Max Filippov wrote:
>> On Mon, Sep 2, 2013 at 7:31 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>>> On 31 August 2013 14:35, Martin MOKREJŠ <mmokrejs@gmail.com> wrote:
>>>>   never realized that my CPUs are gone if I compile into kernel kmemleak.
>>>> Is that really the aim?
>>>>
>>>> CONFIG_HAVE_DEBUG_KMEMLEAK=y
>>>> CONFIG_DEBUG_KMEMLEAK=y
>>>> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
>>>> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
>>>> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
>>>>
>>>> 1.  Why isn't there /sys/devices/system/cpu/cpu0/online file?
>>>> Does not matter if it contains 0 or 1. It just should exist.
>>>
>>> I can't really see how kmemleak would do this, maybe other config
>>> options that get set/cleared in the process of selecting kmemleak. Can
>>
>> Seems to be kmemcheck: from arch/x86/mm/kmemcheck/kmemcheck.c:
>>
>> int __init kmemcheck_init(void)
>> {
>> #ifdef CONFIG_SMP
>>         /*
>>          * Limit SMP to use a single CPU. We rely on the fact that this code
>>          * runs before SMP is set up.
>>          */
>>         if (setup_max_cpus > 1) {
>>                 printk(KERN_INFO
>>                         "kmemcheck: Limiting number of CPUs to 1.\n");
>>                 setup_max_cpus = 1;
>>         }
>> #endif
> 
> Ah, ok, not my problem then ;)


Fine, so would somebody please update the help text accessible in "menuconfig"
for this entry? It should be clear that it has a huge performance impact if enabled.
And, by compiling in it is enabled by default.

Thank you
Martin
