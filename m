Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3BOQzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:55:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab3BOQzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:55:11 -0500
Date: Fri, 15 Feb 2013 11:29:59 -0500
From: Don Zickus <dzickus@redhat.com>
To: anish singh <anish198519851985@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, akpm@linux-foundation.org,
        tglx@linutronix.de, chuansheng.liu@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Watchdog][Trivial] Added comments to explain
 watchdog_disabled variable
Message-ID: <20130215162959.GF98867@redhat.com>
References: <1359907275-15410-1-git-send-email-anish198519851985@gmail.com>
 <CAK7N6vpT_X7s7Vid0-EYenb0w7k=nL8d-ov=fExFMuSYcV47Wg@mail.gmail.com>
 <20130213092101.GD7630@gmail.com>
 <CAK7N6vqh_c31bWiHgVgJLLckya7mykshMKYiqLTdkScMCoXcsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7N6vqh_c31bWiHgVgJLLckya7mykshMKYiqLTdkScMCoXcsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 03:28:00PM +0530, anish singh wrote:
> On Wed, Feb 13, 2013 at 2:51 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * anish singh <anish198519851985@gmail.com> wrote:
> >
> >> Is the below patch picked up?
> >>
> >> On Sun, Feb 3, 2013 at 9:31 PM, anish kumar <anish198519851985@gmail.com> wrote:
> >> > From: anish kumar <anish198519851985@gmail.com>
> >> >
> >> > This watchdog_disabled flag is bit of cryptic.Howerver it's usefullnes is multifold.
> >> > Uses are:
> >> > 1. Check if smpboot_register_percpu_thread function passed.
> >> > 2. Makes sure that user enables and disables the watchdog in sequence
> >> >    i.e. enable watchdog->disable watchdog->enable watchdog
> >> >    Unlike enable watchdog->enable watchdog which is wrong.
> >> >
> >> > Signed-off-by: anish kumar <anish198519851985@gmail.com>
> >> > ---
> >> >  kernel/watchdog.c |    5 +++++
> >> >  1 files changed, 5 insertions(+), 0 deletions(-)
> >> >
> >> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> >> > index 75a2ab3..87a19aa 100644
> >> > --- a/kernel/watchdog.c
> >> > +++ b/kernel/watchdog.c
> >> > @@ -518,6 +518,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
> >> >                 return ret;
> >> >
> >> >         set_sample_period();
> >> > +       /*
> >> > +        * We shouldn't enable watchdog threads if it is
> >> > +        * disabled.This is done by watchdog_disabled
> >> > +        * variable check in watchdog_*_all_cpus function.
> >
> > It has two grammatic and a stylistic error in it, plus misses
> Would you mind pointing it out to me the grammatical mistakes
> as I am not that good with grammar.

I am not entirely sure which ones Ingo is referring to, but what I see are

'disabled.This' needs a space after period
'This is done by watchdog_disabled' needs a 'the' after 'by'
'variable check in watchdog..' needs a 'the' after 'in'.

in addition to the missing ()'s after 'watchdog_*_all_cpus.

Unless I am missing something else, I think that is it.

Cheers,
Don

> I thought I followed the conventions as below:
> /*
>  *
>  *
>  */
> > the convention that function names are mentioned with a '()'.
> >
> > Thanks,
> >
> >         Ingo
