Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934748Ab3JPOT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:19:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:15350 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934611Ab3JPOTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:19:54 -0400
Message-ID: <525EA083.2070006@atmel.com>
Date: Wed, 16 Oct 2013 16:19:47 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, Marc Pignat <marc.pignat@hevs.ch>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, <kernel@pengutronix.de>,
        John Stulz <john.stultz@linaro.org>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] fixes for integer rounding in timer core
References: <alpine.DEB.2.02.1309191629040.4089@ionos.tec.linutronix.de> <1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de> <5253D9A1.1080106@pengutronix.de> <20131008153147.GR10079@pengutronix.de> <20131014073436.GX10079@pengutronix.de>
In-Reply-To: <20131014073436.GX10079@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/2013 09:34, Uwe Kleine-König :
> Hello Linus, hello Ingo,
>
> On Tue, Oct 08, 2013 at 05:31:47PM +0200, Uwe Kleine-König wrote:
>>> What's the status of this patch?
>> I pinged Thomas about it already via irc, but I didn't get a response up
>> to now. It would be great to get that into 3.12. To make it easy for
>> Thomas, here is a pull request that includes the fix and converts
>> at91rm9200 back to clockevents_config_and_register dropping one of the
>> workarounds for the fixed bug.
>>
>> The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:
>>
>>    Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)
>>
>> are available in the git repository at:
>>
>>    git://git.pengutronix.de/git/ukl/linux.git tags/timer-for-tip
>>
>> for you to fetch changes up to b58c4b70121070f45eefa739ecbb58d57da1c4d9:
>>
>>    ARM: at91: rm9200: switch back to clockevents_config_and_register (2013-10-08 16:58:22 +0200)
>>
>> ----------------------------------------------------------------
>> The first patch in this pull request fixes an old integer rounding bug in the
>> timer core that was (and still is) worked around in a few arch's timer code.
>> The second patch drops such a work around now that the core is fixed.
> It would be nice to get that fix into 3.12, but Thomas stopped
> responding nearly a month ago---his last mail in this thread[1] dates back
> to September 20.
>
> Can one of you please take it directly?

I second Uwe in his request (aka +1).

Thanks, bye,


> [1] http://thread.gmane.org/gmane.linux.kernel/1563370/
>> ----------------------------------------------------------------
>> Thomas Gleixner (1):
>>        clockevents: Sanitize ticks to nsec conversion
>>
>> Uwe Kleine-König (1):
>>        ARM: at91: rm9200: switch back to clockevents_config_and_register
>>
>>   arch/arm/mach-at91/at91rm9200_time.c |  7 ++--
>>   kernel/time/clockevents.c            | 65 +++++++++++++++++++++++++++---------
>>   2 files changed, 52 insertions(+), 20 deletions(-)
>>
>> --
>> Pengutronix e.K.                           | Uwe Kleine-König            |
>> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>


-- 
Nicolas Ferre
