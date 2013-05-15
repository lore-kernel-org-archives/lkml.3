Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab3EOTlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:41:11 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56126 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab3EOTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:41:08 -0400
Date: Wed, 15 May 2013 21:41:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, tony.luck@intel.com, bp@alien8.de, tglx@linutronix.de,
        prarit@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Don't invoke
 tick_nohz_stop_sched_tick( ) if the cpu is offline
Message-ID: <20130515194102.GE24004@somewhere>
References: <alpine.LFD.2.02.1305132138160.2863@ionos>
 <tip-f7ea0fd639c2c48d3c61b6eec75362be290c6874@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-f7ea0fd639c2c48d3c61b6eec75362be290c6874@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 08:46:59AM -0700, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  f7ea0fd639c2c48d3c61b6eec75362be290c6874
> Gitweb:     http://git.kernel.org/tip/f7ea0fd639c2c48d3c61b6eec75362be290c6874
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Mon, 13 May 2013 21:40:27 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 14 May 2013 17:40:31 +0200
> 
> tick: Don't invoke tick_nohz_stop_sched_tick() if the cpu is offline
> 
> commit 5b39939a4 (nohz: Move ts->idle_calls incrementation into strict
> idle logic) moved code out of tick_nohz_stop_sched_tick() and missed
> to bail out when the cpu is offline. That's causing subsequent
> failures as an offline CPU is supposed to die and not to fiddle with
> nohz magic.

I don't see the logic has changed after this commit. The old nohz
code was already shutting down the tick on offline CPUs.

Am I missing something?
I'm not sure which behaviour we want though, nor what the side
effect could be whether we keep or shutdown the tick.

There is also the problem of full dynticks CPUs that have their
tick stopped and then get later offlined. They may end up in the idle loop
with the tick already stopped and it's not going to be restarted. I believe
that can trigger the same issue.

I'm just not sure what I should do: restart the tick when the CPU
is offlining? What could be the side effect of that?

Thanks.
