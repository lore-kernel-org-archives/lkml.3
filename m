Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaCGOw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:52:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:40067 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750958AbaCGOw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:52:26 -0500
Date: Fri, 7 Mar 2014 09:52:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        stable-rt@vger.kernel.org
Subject: Re: [PATCH RT 3/6] rt: Make cpu_chill() use hrtimer instead of
 msleep()
Message-ID: <20140307095223.2f412a1a@gandalf.local.home>
In-Reply-To: <531996BB.2050401@linutronix.de>
References: <20140305003333.402759240@goodmis.org>
	<20140305003346.602499217@goodmis.org>
	<531996BB.2050401@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Mar 2014 10:51:55 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 03/05/2014 01:33 AM, Steven Rostedt wrote:
> > 3.2.55-rt79-rc1 stable review patch.
> > If anyone has any objections, please let me know.
> 
> Now that you posted "cpu_chill: Add a UNINTERRUPTIBLE
> hrtimer_nanosleep" wouldn't it make sense to delay this patches from
> the stable series until we get them all in one go?

Sure, say this on the day I'm about to release ;-)

Nah, I'll release these today anyway. Otherwise I can't update to the
mainline stables. When the rc candidates are out, it holds up any new
updates to the versions.

Also, the stable 3.10 has this bug already. Might as well update all
the stables with the same fix. It makes it easier on my side, as the
way I do the updates is to use the same quilt queue for all releases. I
start with 3.10, and get them working, and then apply the same queue to
3.8. Any conflicts in the patch I do a quilt fork, with a -v3.8
appended, and then after getting that working I go to 3.4, and so on.
This also lets me drop patches that are not applicable for earlier
releases.

If I delay this for a new update, then 3.10 will be out of sync. I'm
just going to release these, and then we can start a new one right away.

Thanks!

-- Steve
