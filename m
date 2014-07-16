Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934856AbaGPG7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:59:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:53390 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812AbaGPG7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:59:10 -0400
Date: Wed, 16 Jul 2014 08:59:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Miroslav Lichvar <mlichvar@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering (v2)
In-Reply-To: <53C5F95E.6010300@linaro.org>
Message-ID: <alpine.DEB.2.10.1407160858260.24854@nanos>
References: <1400288204-414-1-git-send-email-john.stultz@linaro.org> <20140519101439.GE4060@localhost> <CALAqxLUyCGJeYDwzXKN0zCBdmYuapo1iYJX4nvR7Sru+ySkesQ@mail.gmail.com> <20140708110816.GB23173@localhost> <53C5F95E.6010300@linaro.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, John Stultz wrote:

> On 07/08/2014 04:08 AM, Miroslav Lichvar wrote:
> > On Mon, May 19, 2014 at 10:57:29AM -0700, John Stultz wrote:
> >> Another area we have to be careful with is there are still
> >> architectures (powerpc and ia64) which haven't switched from the old
> >> vsyscall rounding logic (CONFIG_GENERIC_TIME_VSYSCALL_OLD). In these
> >> cases we add up to 1ns of error each tick/update as we round up the
> >> sub-nanoseconds to ensure we don't see inconsistencies.  If the
> >> adjustment logic can't handle this, I don't want to regress those
> >> arches.
> > I spent some time trying to figure out a workaround for the nanosecond
> > rounding, but I didn't find anything that wouldn't complicate the mult
> > adjustment logic and bring back the problems which the direct division
> > approach is supposed to solve.
> >
> > It seems it may be a while before the old vsyscalls are fixed. How
> > about including only the first two patches from this set for now?
> 
> Hey! Sorry for the slow response here, I was on the road the last two weeks.
> 
> So thanks for the ping here. If you're happy with the first two as an
> initial step, I'd be willing to try to push those in. The only trouble
> is there's a whole lot of timekeeping churn headed for 3.17 that Thomas
> has cooked up. While there isn't likely to be direct conflicts in the
> changes, I get nervous about mixing too many changes in subtle code at once.
> 
> But maybe I'm being overly cautious?
> 
> Thomas: Would you be ok if I push you some patches to improve ntp/ptp
> freq steering w/ NOHZ for this merge window as well? So far the patches
> have only shown nice improvements and no regressions, but its clearly
> subtle code, and there's a lot going on in this merge window.

I think it's ok. The steering is orthogonal to the other stuff cooking.

Thanks,

	tglx
