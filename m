Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaCKTwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:52:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62551 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754711AbaCKTwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:52:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Rik van Riel <riel@redhat.com>
Cc: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>, linux-pm@vger.kernel.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 0/7] Cpuidle: Minor fixes
Date: Tue, 11 Mar 2014 21:07:30 +0100
Message-ID: <1835648.TNmyQZGz12@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <531F656A.1070905@redhat.com>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org> <2675767.poCYkWDpin@vostro.rjw.lan> <531F656A.1070905@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 11, 2014 03:35:06 PM Rik van Riel wrote:
> On 03/07/2014 07:12 AM, Rafael J. Wysocki wrote:
> > On Wednesday, February 26, 2014 01:46:25 AM Rafael J. Wysocki wrote:
> >> On Monday, February 24, 2014 08:29:30 AM Tuukka Tikkanen wrote:
> >>> This set of patches makes some minor changes to menu governor and the poll
> >>> idle state.
> >>>
> >>> Patch 1 is simply a rename of a variable to make the name better represent
> >>> the contained information.
> >>>
> >>> Patch 2 fixes calculating actual residency in cases where the entered state
> >>> is different from the state decided by the menu governor.
> >>>
> >>> Patch 3 makes sure the menu governor timer coefficients are not updated
> >>> with values that might cause a coefficient to reach a value greater than
> >>> unity.
> >>>
> >>> Patch 4 fixes calculation actual residency in cases where the entered state
> >>> does not support measuring residency. In such cases the residency time
> >>> is taken from time remaining until next timer expiry. The timer is expected
> >>> to go off at the start of exit latency, not after it. Therefore the exit
> >>> latency must not be substracted from the assumed value.
> >>>
> >>> Patch 5 moves the performance multiplier based comparison out of the state
> >>> selection loop by changing it into a latency requirement. This allows
> >>> using a generic state selection function accepting only (duration, latency)
> >>> tuple as input. The change is possible by noting that performance multiplier
> >>> is used only to check for a minimum predicted idle duration to exit latency
> >>> ratio. As predicted idle duration is a constant for the loop, the maximum
> >>> allowed latency can be calculated outside of the loop.
> >>>
> >>> Patch 6 prevents using negative values from tick_nohz_get_sleep_length()
> >>> in the menu governor. If unchecked, the negative values are used as huge
> >>> unsigned values. Negative values occur fairly often (e.g. on x86_64 I've
> >>> seen this happen several times per minute) on a busy system, allowing
> >>> the deepest state to win the selection while the shallowest should be picked.
> >>>
> >>> Patch 7 adds CPUIDLE_FLAG_TIME_VALID to poll_idle. I do not know of any
> >>> platfrom where cpu_relax() would break ktime_get() and in fact poll_idle
> >>> uses ktime_get itself.
> >>> (Note: poll_idle updates dev->last_residency for some reason. Does it ever
> >>> get called without going through cpuidle_enter_state, which will overwrite
> >>> the value? Even if some state redirects to this state, the call will
> >>> eventually return to the framework. The redundant time measurement could
> >>> be removed, unless there is some obscure way of getting called on some
> >>> platform that I am unable to figure out.)
> >>>
> >>> Tuukka Tikkanen (7):
> >>>    Cpuidle: rename expected_us to next_timer_us in menu governor
> >>>    Cpuidle: Use actual state latency in menu governor
> >>>    Cpuidle: Ensure menu coefficients stay within domain
> >>>    Cpuidle: Do not substract exit latency from assumed sleep length
> >>>    Cpuidle: Move perf multiplier calculation out of the selection loop
> >>>    Cpuidle: Deal with timer expiring in the past
> >>>    Cpuidle: poll state can measure residency
> >>>
> >>>   drivers/cpuidle/driver.c         |    2 +-
> >>>   drivers/cpuidle/governors/menu.c |   85 ++++++++++++++++++++++++--------------
> >>>   2 files changed, 54 insertions(+), 33 deletions(-)
> >>
> >> I'm queuing this series up for 3.15.
> >
> > Patch [6/7] dropped, because of the Len's objection.
> 
> Did a replacement for patch 6/7 (fix the timer code so it
> does not return a negative expiry time) get written and
> merged somewhere? :)

Not that I know of.

> I have been looking at the menu governor too recently,
> but at a different aspect. I'll send out an RFC patch
> soon (which will probably be shot down, and start
> a discussion).

OK

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
