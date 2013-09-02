Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab3IBPpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:45:15 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:52836 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab3IBPox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:44:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkRjk4g4-ig1zyX7qYO2byVhQQK0kZ4rgRCWU141hd-3c3==w@mail.gmail.com>
References: <5221F119.4070000@gmail.com>
	<CAHkRjk4g4-ig1zyX7qYO2byVhQQK0kZ4rgRCWU141hd-3c3==w@mail.gmail.com>
Date: Mon, 2 Sep 2013 19:44:52 +0400
Message-ID: <CAMo8BfLMex3H1QBk6gD7DDDgGJ4dh6+dvhLG=c7LdFZ8XuyM9Q@mail.gmail.com>
Subject: Re: 3.10.9: kmemleak disables all CPUs except CPU0
From: Max Filippov <jcmvbkbc@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: =?UTF-8?Q?Martin_MOKREJ=C5=A0?= <mmokrejs@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 7:31 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On 31 August 2013 14:35, Martin MOKREJŠ <mmokrejs@gmail.com> wrote:
>>   never realized that my CPUs are gone if I compile into kernel kmemleak.
>> Is that really the aim?
>>
>> CONFIG_HAVE_DEBUG_KMEMLEAK=y
>> CONFIG_DEBUG_KMEMLEAK=y
>> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
>> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
>> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
>>
>> 1.  Why isn't there /sys/devices/system/cpu/cpu0/online file?
>> Does not matter if it contains 0 or 1. It just should exist.
>
> I can't really see how kmemleak would do this, maybe other config
> options that get set/cleared in the process of selecting kmemleak. Can

Seems to be kmemcheck: from arch/x86/mm/kmemcheck/kmemcheck.c:

int __init kmemcheck_init(void)
{
#ifdef CONFIG_SMP
        /*
         * Limit SMP to use a single CPU. We rely on the fact that this code
         * runs before SMP is set up.
         */
        if (setup_max_cpus > 1) {
                printk(KERN_INFO
                        "kmemcheck: Limiting number of CPUs to 1.\n");
                setup_max_cpus = 1;
        }
#endif

-- 
Thanks.
-- Max
