Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3HWKJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:09:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46384 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3HWKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:09:19 -0400
Date: Fri, 23 Aug 2013 12:09:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched_delayed] sched: RT throttling activated
Message-ID: <20130823100913.GQ31370@twins.programming.kicks-ass.net>
References: <521722EE.70209@fold.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521722EE.70209@fold.natur.cuni.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 10:53:02AM +0200, Martin Mokrejs wrote:
> Hi,
>   I tried to figure out what this message really means. I came to 
> https://rt.wiki.kernel.org/index.php/Frequently_Asked_Questions
> but I am still lost. I lack in the FAQ some user-related information.
> The first paragraph is still unclear to me. I have a i7-2640M based
> laptop, hyperthreading is enabled by BIOS but I shut down the two
> emulated cores by (no BIOS option to disable HT):
> 
> Would you please clarify what the "[sched_delayed] sched: RT throttling activated"
> really means? 

It means you have (a) real-time task(s) that consume significant amount
of time. At some point we throttle them in an attempt to keep the system
from falling over.

> Is that because there is some RT-requiring application on my system?

Yep.

> I don't know of any (or don't care about real-time responsiveness except that ALSA
> drivers require me to have CONFIG_SND_HRTIMER=y). Per Goggle answers could the
> culprit be nfsd? Then I will recompile is as a module.

Unlikely, I don't think I've ever seen anybody run their nfsd with RT
priority. Also, you can run RT tasks regardless of the config options.
SCHED_RR and SCHED_FIFO are POSIX specified and always available.
