Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336Ab3GWXkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:40:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35102 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968Ab3GWXkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:40:41 -0400
Date: Tue, 23 Jul 2013 16:40:40 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, Barry Song <baohua.song@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Remove ARM local timer API
Message-ID: <20130723234040.GB27761@codeaurora.org>
References: <20130625200211.GA11625@codeaurora.org>
 <CAOesGMj5AZcB7-kcS8_JqfKAg_RUKqTdDZf7bdwkebn3pwADAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMj5AZcB7-kcS8_JqfKAg_RUKqTdDZf7bdwkebn3pwADAw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23, Olof Johansson wrote:
> On Tue, Jun 25, 2013 at 1:02 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > Olof/Arnd,
> >
> > These patches remove the ARM local timer API. The ARM architected
> > timers have already moved away from this API so this series
> > migrates the rest of the users allowing us to remove the API
> > entirely. Thomas has been kind enough to take the first two
> > patches into timers/core in the tip tree (thanks Thomas!) so I've
> > merged that into v3.10-rc1 and then applied the rest of the
> > patches on top. Let me know if this is acceptable.
> >
> > These patches have been through multiple rounds and tested by
> > multiple people since before the 3.10 merge window closed. Only
> > Barry's ack is missing (Cced).
> >
> > Since I don't have a tree on kernel.org, David Brown has been
> > kind enough to push my tag out to his repo. Please pull.
> >
> > The following changes since commit 42cba6e27c4cddc4df701c597dbfa666e1c013c8:
> >
> >   Merge branch 'timers/core' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into remove-local-timers (2013-06-24 17:45:02 -0700)
> >
> > are available in the git repository at:
> >
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/remove-local-timers
> >
> > for you to fetch changes up to 060fd3043e5e3488504b9e70182e188dd9113aea:
> >
> >   ARM: smp: Remove local timer API (2013-06-24 17:47:34 -0700)
> >
> > ----------------------------------------------------------------
> > Now that we have a generic arch hook for broadcast we can remove the local
> > timer API entirely. Doing so will reduce code in ARM core, reduce the
> > architecture dependencies of our timer drivers, and simplify the code because
> > we no longer go through an architecture layer that is essentially a hotplug
> > notifier.
> 
> Hi,
> 
> Merged in as localtimer/removal into next/cleanup.
> 
> I had quite a few merge conflicts due to the __cpuinit removal, so
> please double-check my resolutions.
> 

A __cpuinit is leftover in smp_twd.c. Hopefully you can just
redo the merge?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
