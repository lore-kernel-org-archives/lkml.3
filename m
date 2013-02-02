Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab3BBDRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 22:17:01 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51701 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab3BBDQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 22:16:57 -0500
Subject: Re: [PATCH] [Watchdog][Trivial] Added comments to explain
 watchdog_disabled variable
From: anish kumar <anish198519851985@gmail.com>
To: akpm@linux-foundation.org
Cc: tglx@linutronix.de, mingo@kernel.org, chuansheng.liu@intel.com,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>
In-Reply-To: <20130201145934.GQ98867@redhat.com>
References: <1359726547-21205-1-git-send-email-anish198519851985@gmail.com>
	 <20130201145934.GQ98867@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Feb 2013 08:46:39 +0530
Message-ID: <1359774999.1666.32.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-01 at 09:59 -0500, Don Zickus wrote:
> On Fri, Feb 01, 2013 at 07:19:07PM +0530, anish kumar wrote:
> > From: anish kumar <anish198519851985@gmail.com>
> > 
> > This watchdog_disabled flag is bit of cryptic.Howerver it's usefullnes is multifold.
> > Uses are:
> > 1. Check if smpboot_register_percpu_thread function passed.
> > 2. Makes sure that user enables and disables the watchdog in sequence
> >    i.e. enable watchdog->disable watchdog->enable watchdog
> >    Unlike enable watchdog->enable watchdog which is wrong.
> > 
> > Signed-off-by: anish kumar <anish198519851985@gmail.com>
> > ---
> >  kernel/watchdog.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> > index 6ef638b..dfd843a 100644
> > --- a/kernel/watchdog.c
> > +++ b/kernel/watchdog.c
> > @@ -519,6 +519,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
> >  		return ret;
> >  
> >  	set_sample_period();
> > +	/*
> > +	 * We shouldn't enable watchdog threads if it is not
> 							^^^
> the 'not' is not needed I believe.  Other than that, if it helps
> to understand the code better.  I am fine with it.
> 
> Acked-by: Don Zickus <dzickus@redhat.com>
Should I wait for some more acked-by's?
> 
> > +	 * disabled.This is done by watchdog_disabled
> > +	 * variable check in watchdog_*_all_cpus function.
> > +	 */
> >  	if (watchdog_enabled && watchdog_thresh)
> >  		watchdog_enable_all_cpus();
> >  	else
> > -- 
> > 1.7.1
> > 


