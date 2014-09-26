Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaIZK6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:58:34 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37881 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaIZK6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:58:32 -0400
Message-ID: <1411729103.3852.19.camel@hornet>
Subject: Re: [PATCH v2 1/2] perf: Add sampling of the raw monotonic clock
From: Pawel Moll <pawel.moll@arm.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Fri, 26 Sep 2014 11:58:23 +0100
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	 <1411491787-25938-2-git-send-email-pawel.moll@arm.com>
	 <87sijhk21x.fsf@sejong.aot.lge.com> <1411642198.4768.30.camel@hornet>
	 <8738bekith.fsf@sejong.aot.lge.com>
In-Reply-To: <8738bekith.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2014-09-26 at 07:16 +0100, Namhyung Kim wrote:
> > It would be doable, I guess, but what
> > if someone *wants* to have sched clock as the timestamps source (because
> > it's cheap) but still be able to correlate them with userspace? In this
> > case two separate timestamps are required to do the approximation.
> 
> But by collecting two timestamps, you'll loose the win of the first
> timestamp, no?

But I can ask for both timestamps only being collected on "low
bandwidth" events, in particular context switches and/or periodic (eg.
10ms hrtimer) software events.

Then I have loads of normal normal samples, timestamped with sched clock
only, and every now and then one with both timestamps which then I can
use for time correlation. The whole point is that the frequency of such
"synchronisation" event can be much (much!) lower than of the normal
samples, but it still allows pretty good approximation (I was getting
accuracy of ~1 microsecond and better with sched_switch trace event
marked with additional raw monotonic timestamp).

Pawel

PS. Have you sent a couple of the messages via some kind of gmane's
proxy? All the mail addresses got rather messed up...

