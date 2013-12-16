Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3LPNvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:51:04 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:41850 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3LPNvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:51:00 -0500
MIME-Version: 1.0
In-Reply-To: <87eh5drnsq.fsf@nemi.mork.no>
References: <52A448F2.4010208@redhat.com>
	<CAKohpomO+0q7bFWTnFRgqoRuU2WryfPpFv0WLOCKtHBrLzLRqw@mail.gmail.com>
	<87iouprrcw.fsf@nemi.mork.no>
	<CAKohpok+EqA+ujCwzQvL2C7YAyfueGAd4XUXGqvdz2tm5_A0QQ@mail.gmail.com>
	<87eh5drnsq.fsf@nemi.mork.no>
Date: Mon, 16 Dec 2013 19:21:00 +0530
Message-ID: <CAKohponvbNOrxgNq2ubNcJ=_u=6uSTohK7KO2jHxsnmgwDM8=A@mail.gmail.com>
Subject: Re: Regression with suspend resume 5a87182aa21d6d5d306840feab9321818dd3e2a3
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, jinchoi@broadcom.com,
        Paul Bolle <pebolle@tiscali.nl>,
        ziegler@email.mathematik.uni-freiburg.de,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        jbarnes@virtuousgeek.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 December 2013 17:49, Bjørn Mork <bjorn@mork.no> wrote:
> Viresh Kumar <viresh.kumar@linaro.org> writes:

>> As a summary, after my patch to suspend/resume governors we can't
>> allow policies to be freed and allocated back.
>
> How do you deal with errors on suspend/resume then?  Are you always able
> to keep the policies, for all error cases?

We fixed that with http://www.spinics.net/lists/cpufreq/msg08720.html, isn't it?

> In any case: Splitting the suspend code between a cpu hotplug hook with
> special "frozen" logic and a cpufreq_suspend() called from
> dpm_suspend_noirq() confuses me, and I believe many others.  This is the
> reason such a bug could be caused by two "obviously fine" patches.  So
> please, at least keep the suspend logic in *one* place.

This fixes it I believe.

https://lkml.org/lkml/2013/12/2/26

Specially patch 3/3

>> Its not really a war between my patch versus yours :), but I believe the
>> right thing to do at this point is to get two patches in for 3.13 as well:
>>
>> 5a87182 cpufreq: suspend governors on system suspend/hibernate
>> and patch discussed here:
>> http://www.spinics.net/lists/cpufreq/msg08720.html
>
> Yes, that would probably work fine, at least as long as nothing goes
> wrong.  I must admit that I'm in no way able to play out all the
> different error scenarios in my head, but won't there still be cases
> where you end up freeing policies on suspend/resume?

No, we aren't supposed to free policies at all in suspend/resume..

>> To finish this problem as early as possible I tested above two
>> patches and didn't saw any regressions with suspend/resume or
>> Hibernation.. And obviously this fixes your issues as well :)
>>
>> @Rafael: I understand that it would be difficult for you to take these
>> now for 3.13 but they fix some serious problems reported earlier.
>> Specially the first patch which everybody thought is the culprit :)
>>
>> Please see if we can manage to get them in :)
>
> I think it needs serious testing with simulated errors first.  All error
> labels should be executed at least once for all combinations of inputs.

That can be best done by the people who reported these issues. And
you are one of those :)

I will ask others also to give these patches a try. .That would be
helpful.

> Simply trying it out and verifying that it works in the no-error case is
> not enough.  Which should be quite obvious now.

Sure.. But I already tested it earlier as well, when I sent that patch to
you. I tested it on top of my branch where the reverted patch was
present. So, for me they should work fine..

--
viresh
