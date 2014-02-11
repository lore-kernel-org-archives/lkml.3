Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaBKIuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:50:02 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62759 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKIuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:50:00 -0500
Date: Tue, 11 Feb 2014 09:49:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] A couple of sched patches
Message-ID: <20140211084956.GB26063@gmail.com>
References: <1392107067-19907-1-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392107067-19907-1-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Juri Lelli <juri.lelli@gmail.com> wrote:

> This two patches (on top of tip/master as of today) fix bugs
> in sched/core. First one is a repost of
> http://comments.gmane.org/gmane.linux.kernel/1638425, and exposed,
> at least to me, another bug (fixed by second patch).

With today's -tip there's a new warning on UP builds:

  /home/mingo/tip/kernel/sched/deadline.c:993: warning: 'pull_dl_task' declared 'static' but never defined

And in general the #ifdef happiness of deadline.c is rather sad:

 comet:~/tip> grep '#ifdef' kernel/sched/deadline.c 
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SCHED_HRTICK
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SCHED_HRTICK
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SCHED_HRTICK
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SMP
 #ifdef CONFIG_SMP

All that needs to be cleaned up.

Thanks,

	Ingo
