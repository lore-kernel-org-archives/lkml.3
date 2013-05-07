Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab3EGISF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:18:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52683 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab3EGISA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:18:00 -0400
Message-ID: <5188B8B2.5030601@arm.com>
Date: Tue, 07 May 2013 09:17:54 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] ARM: delay: print dummy values for bogomips
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com> <1367602547-19322-2-git-send-email-will.deacon@arm.com> <20130506231554.GB16801@amd.pavel.ucw.cz>
In-Reply-To: <20130506231554.GB16801@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 07 May 2013 08:17:55.0121 (UTC) FILETIME=[602E3210:01CE4AFB]
X-MC-Unique: 113050709175804001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/13 00:16, Pavel Machek wrote:

Hi Pawel,

>> Now that we support a timer-backed delay loop, I'm quickly getting sick
>> and tired of people complaining that their beloved bogomips value has
>> decreased. You know who you are!
> 
>> Unfortunately, we can't just remove the entry from /proc/cpuinfo, as it
>> will likely break fragile userspace code which is parsing that stuff, so
>> instead replace it with a dummy value that can be chosen in the
>> Kconfig.
> 
> So, instead of removing it you silently report invalid value? Note

Removing it would be an ABI breakage. Unfortunately.

> that there's no cpumhz display in procinfo... at least on OLPC I
> looked.

And? What does the CPU frequency bring you when any modern CPU has some
kind of cpufreq support that renders this information information pretty
much meaningless?

> And whether it is 30MHz or 3GHz cpu might be relevant information for
> userspace, and yes, bogomips used to be good enough for that.

Name one userspace application that extracts meaningful information out
of the BogoMIPS field. Just one.

> Actually it was mhz, mhz/2 or mhz*2 on pretty much all reasonable systems.

So any number within a ratio from one to four is good enough for you?
Wow. That pretty much proves the usefulness of this patch.

Additionally, having switched arch_timer capable CPUs to a timer based
delay instead of a loop-based delay means your precious pseudo-frequency
is now a thing of the past. And guess what? Nothing broke so far.
Because using BogoMIPS to deduct anything is *bogus*.

Timer-based delay calibration has been around for about ages. I still
remember the day (some 10 or 12 years ago) when DaveM switched the
UltraSPARC port to use the timer, and my BogoMIPS went from ~1000 to 12.
People moaned, DaveM held his position, and nothing happened. *Nothing*.
End of story.

	M.
-- 
Jazz is not dead. It just smells funny...

