Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3GORJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab3GORJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:09:13 -0400
Date: Mon, 15 Jul 2013 13:08:59 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: rostedt@goodmis.org, fweisbec@gmail.com
Subject: Re: nohz: Warn if the machine can not perform nohz_full
Message-ID: <20130715170859.GA25570@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	rostedt@goodmis.org, fweisbec@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=e12d0271774fea9fddf1e2a7952a0bffb2ee8e8b
 > Commit:     e12d0271774fea9fddf1e2a7952a0bffb2ee8e8b
 > Parent:     7d132055814ef17a6c7b69f342244c410a5e000f
 > Author:     Steven Rostedt <rostedt@goodmis.org>
 > AuthorDate: Fri May 10 17:12:28 2013 -0400
 > Committer:  Frederic Weisbecker <fweisbec@gmail.com>
 > CommitDate: Thu Jun 20 01:15:51 2013 +0200
 > 
 >     nohz: Warn if the machine can not perform nohz_full
 >     
 >     If the user configures NO_HZ_FULL and defines nohz_full=XXX on the
 >     kernel command line, or enables NO_HZ_FULL_ALL, but nohz fails
 >     due to the machine having a unstable clock, warn about it.
 >     
 >     We do not want users thinking that they are getting the benefit
 >     of nohz when their machine can not support it.
 > ---
 >  kernel/time/tick-sched.c |    5 +++++
 >  1 files changed, 5 insertions(+), 0 deletions(-)
 > 
 > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
 > index f420813..d87d22c 100644
 > --- a/kernel/time/tick-sched.c
 > +++ b/kernel/time/tick-sched.c
 > @@ -178,6 +178,11 @@ static bool can_stop_full_tick(void)
 >  	 */
 >  	if (!sched_clock_stable) {
 >  		trace_tick_stop(0, "unstable sched clock\n");
 > +		/*
 > +		 * Don't allow the user to think they can get
 > +		 * full NO_HZ with this machine.
 > +		 */
 > +		WARN_ONCE(1, "NO_HZ FULL will not work with unstable sched clock");
 >  		return false;
 
So I guess you guys never want this to be enabled on distro kernels ?
If that's the case, can you add something to that effect in Kconfig ?

	Dave

