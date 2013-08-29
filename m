Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3H2SRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:17:05 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:63029 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab3H2SRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:17:04 -0400
Message-ID: <521F901B.3090305@gmail.com>
Date: Thu, 29 Aug 2013 20:16:59 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 14/16] ARM: vexpress: remove custom .init_time
 hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-15-git-send-email-sebastian.hesselbarth@gmail.com> <201308291535.53005.arnd@arndb.de>
In-Reply-To: <201308291535.53005.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/13 15:35, Arnd Bergmann wrote:
> On Tuesday 27 August 2013, Sebastian Hesselbarth wrote:
>> @@ -422,16 +419,8 @@ void __init v2m_dt_init_early(void)
>>                          pr_warning("vexpress: DT HBI (%x) is not matching "
>>                                          "hardware (%x)!\n", dt_hbi, hbi);
>>          }
>> -}
>> -
>> -static void __init v2m_dt_timer_init(void)
>> -{
>> -       of_clk_init(NULL);
>>
>> -       clocksource_of_init();
>> -
>> -       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
>> -                               24000000);
>> +       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(), 24000000);
>>   }
>
> You are moving versatile_sched_clock_init() ahead of clocksource_of_init(), which I suspect
> won't work. Have you checked this?

"Checked" as in "Tested", no I haven't.

But non-DT v2m has it in v2m_init_early also, while v2m_sp804_init()
is called in v2m_timer_init().

That matches the above approach taken for DT v2m where
versatile_sched_clock_init() is now called from v2m_dt_init_early()
and clocksource_of_init() called from arch-wide .timer_init.

get_maintainer.pl did not spit out any additional maintainer except
Russell of course. You know someone who can test the above?

Sebastian
