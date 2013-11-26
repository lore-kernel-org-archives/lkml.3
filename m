Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab3KZS6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:58:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405Ab3KZS6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:58:45 -0500
Date: Tue, 26 Nov 2013 13:58:33 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: odd userspace lockups.
Message-ID: <20131126185833.GA4121@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20131126182157.GA503@redhat.com>
 <CA+55aFzvc9g896HK2AVU2A37t50PiCL2+tjGzNyn3BJ-om+7fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzvc9g896HK2AVU2A37t50PiCL2+tjGzNyn3BJ-om+7fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:44:16AM -0800, Linus Torvalds wrote:
 
 > > At first I thought it was just being really slow, (especially after seeing
 > > all those congestion related symbols in the stack traces), but even after
 > > being left for hours, it doesn't seem to progress.
 > 
 > It *does* seem to be hung in some congestion thing. Possibly brought
 > on by being low on memory due to a memory leak.
 > 
 > I'm not seeing any suspicious locks: the sshd that holds the mmap_sem
 > locks for a fork() seems to be in congestion-wait for the disk due to
 > trying to allocate memory, exactly like all the trinity children are.
 > 
 > You don't have memory information in your dump, but to me it looks
 > like you're basically out of memory (there's a *lot* of
 > trinity-children trying to allocate pages), and the oom killer isn't
 > triggering for whatever reason.
 > 
 > Of course, it could easily be a kernel memory leak too (rather than
 > trinity), triggered by your odd workload.

So, completely different machine: Yesterday I got back from my vacation to
find my router running 3.12+ from a week earlier had hung completely.
On the screen was some oom killer output.  After bringing it back up
I looked at the mrtg graphs of it for the last week:
http://codemonkey.org.uk/junk/mem.free-week.png
Those stair-steps are around the time of morning that cron runs.

Normally I reboot that machine every day to update to the latest kernel,
but because I was on vacation, it had enough uptime to accumulate a leak.

That machine is just routing packets (and making pretty mrtg graphs) though,
not doing any fuzz testing or anything weird.

Who knows, maybe it's something totally unrelated. I'll keep poking at things,
and try and find an easier way to reproduce it.

	Dave

