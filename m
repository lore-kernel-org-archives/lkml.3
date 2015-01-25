Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbbAYPEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 10:04:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:42466 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbbAYPEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 10:04:04 -0500
Date: Sun, 25 Jan 2015 16:03:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Kevin Hilman <khilman@kernel.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] clockevents: introduce ->set_dev_mode() which can
 return error
In-Reply-To: <CAKohpomZJAymPHVNR9LkHM8V2tkmM=H+btYEiAJ9hq0mAoOzYw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1501251537380.5526@nanos>
References: <1418162614-19182-1-git-send-email-khilman@kernel.org> <1418162614-19182-2-git-send-email-khilman@kernel.org> <alpine.DEB.2.11.1501231223470.5526@nanos> <CAKohpomZJAymPHVNR9LkHM8V2tkmM=H+btYEiAJ9hq0mAoOzYw@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >         case CLOCK_EVT_MODE_RESUME:
> >              return dev->setup_resume(dev);
> 
> Because setting to all these existing modes isn't allowed
> to fail currently, shouldn't we make return type of all the new
> callbacks as 'void' and return 0 from this routine ? That way, these
> callbacks would stay consistent with the set_mode() callback..

If we go to individual callbacks then we analyze of a case by case
basis which ones need a return value and which ones to not.
 
> > That gives us a clear distinction of required and optional callbacks,
> > which will make error handling and recovery simpler as well.
> 
> Now that we are looking forward to providing individual callbacks
> per feature, I wanted to propose few more solutions to it, though I am
> quite sure you would have already considered and rejected them.
> 
> I remember from your earlier mail that you didn't wanted to add
> ONESHOT_STOPPED as a feature (as it isn't a feature really)
> and that restricts us from doing this:
> 
> static int __clockevents_set_mode(dev, mode)
> {
>         if ((mode == CLOCK_EVT_MODE_ONESHOT_STOPPED) &&
>             !(dev->features & CLOCK_EVT_FEAT_ONESHOT_STOPPED))
>                 return -ENOSYS;
> 
>         dev->set_mode(mode, dev);
>         return 0;
> }
> 
> But what about providing a separate callback only for ONESHOT_STOPPED
> mode and use set_mode() for everything else ?

And then fixup all drivers which do not have a default clause in their
switch case and add MODE_ONESHOT_STOPPED? And half a year later we do
the same for the next mode. No way.

The current interface is suboptimal and we fix it proper. Period.

Thanks,

	tglx
