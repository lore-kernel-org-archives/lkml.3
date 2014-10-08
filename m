Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaJHXTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:19:04 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:32864 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaJHXS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:18:58 -0400
Date: Wed, 8 Oct 2014 16:18:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: pinctrl-msm build error on Linus' tree
Message-ID: <20141008231847.GC25134@roeck-us.net>
References: <CA+5PVA4mO+BiTGvrRb7-MLZRV1iQKsmvaDifFLQiqZN1-b88RQ@mail.gmail.com>
 <20141008224908.GX868@joshc.qualcomm.com>
 <CA+5PVA4nJkPZnZ2GfRmj4YBgmBKJBM4cG_3=DC2LXXJtB5=HHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4nJkPZnZ2GfRmj4YBgmBKJBM4cG_3=DC2LXXJtB5=HHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.5435C662.006F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 07:09:18PM -0400, Josh Boyer wrote:
> On Wed, Oct 8, 2014 at 6:49 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> > Hey Josh-
> >
> > On Wed, Oct 08, 2014 at 06:42:55PM -0400, Josh Boyer wrote:
> >> We're hitting a build error on ARM with Linus' tree as of Linux
> >> v3.17-2860-gef0625b70dac :
> >>
> >> drivers/pinctrl/qcom/pinctrl-msm.c: In function 'msm_pinctrl_setup_pm_reset':
> >> drivers/pinctrl/qcom/pinctrl-msm.c:875:4: error: implicit declaration
> >> of function 'register_restart_handler'
> >> [-Werror=implicit-function-declaration]
> >>     if (register_restart_handler(&pctrl->restart_nb))
> >>     ^
> >> drivers/pinctrl/qcom/pinctrl-msm.c: In function 'msm_pinctrl_remove':
> >> drivers/pinctrl/qcom/pinctrl-msm.c:949:2: error: implicit declaration
> >> of function 'unregister_restart_handler'
> >> [-Werror=implicit-function-declaration]
> >>   unregister_restart_handler(&pctrl->restart_nb);
> >>   ^
> >> cc1: some warnings being treated as errors
> >>
> >> Looking at the git logs it seems this was added via:
> >>
> >> commit cf1fc187628913070c3e418ce0e205732435aa2f
> >> Author: Josh Cartwright <joshc@codeaurora.org>
> >> Date:   Tue Sep 23 15:59:53 2014 -0500
> >>
> >>     pinctrl: qcom: use restart_notifier mechanism for ps_hold
> >>
> >>
> >> However, there is literally nothing else in the tree that calls or
> >> provides those functions:
> >>
> >> [jwboyer@vader linux]$ git grep unregister_restart_handler
> >> drivers/pinctrl/qcom/pinctrl-msm.c:     unregister_restart_handler(&pctrl->resta
> >> [jwboyer@vader linux]$
> >>
> >>
> >> I'm rather confused.  How was this commit built and tested?
> >
> > This may be my fault for not clearly stating that this particular patch
> > was dependent on Guenter's restart notifier patchset.  This patch was
> > applied to linusw's tree without these patches.   Perhaps it should be
> > dropped for now until the restart_notifier stuff lands?
> 
> Thanks, that explains things.  I'm not sure if Linus would do a revert
> at this point.  I guess it depends on how fast he's going to merge
> Guenter's patches.
> 
> Is there a reason this wasn't all brought in via one tree?  Seems like
> it should have been.
> 
Too many dependencies all over the place, and thus risk to create merge-time
conflicts. Besides pinctrl, the restart handler infrastructure is already
used by clock, power/restart, and watchdog drivers.

The idea was for me to provide a pointer to an immutable branch
with the infrastructure (which I did), and for all trees using it
to merge with that branch. This way the infrastructure would have been merged
automatically with its first user, and no separate pull request would have
been necessary. Again, I thought we had this well covered. Apparently not,
and of course the one tree who didn't merge the infrastructure got into
mainline first :-(.

Guenter
