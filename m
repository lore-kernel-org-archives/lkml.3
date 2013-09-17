Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3IQUKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:10:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55215 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223Ab3IQUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:10:10 -0400
Message-ID: <1379448607.2213.16.camel@dabdike>
Subject: Re: [PATCH] scsi: delete decade+ obsolete aic7xxx_old driver
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Doug Ledford <dledford@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-scsi list <linux-scsi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Sep 2013 15:10:07 -0500
In-Reply-To: <52386730.4060508@suse.de>
References: <y687fpks4kdsmfuadq4cykip.1379384036544@email.android.com>
	 <52386730.4060508@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-17 at 16:29 +0200, Hannes Reinecke wrote:
> On 09/17/2013 04:13 AM, Doug Ledford wrote:
> > Yes, this driver is well past ready to be removed.
> > 
> > Acked-by: Doug Ledford <dledford@redhat.com>
> > 
> > Sent from my ASUS Pad
> > 
> > Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> > 
> >> After getting warnings in an allyesconfig build[1] from this
> >> driver, I decided to remind myself just how old it was, and
> >> whether it warranted fixing.  In the Kconfig help text, I found:
> >>
> >>  "This driver will eventually be phased out entirely"
> >>
> >> Going back to the history archive, I see the line was added[2]
> >> in Feb 2002, when we moved from v2.4.2.1 ---> v2.4.2.2
> >>
> >> So, with over a decade of notification, and multiple major releases
> >> since then, I think we can justify removing this.  Currently we have
> >> people wasting time building it during routine testing, and then
> >> wasting more time re-researching the known reported warnings, only to
> >> find that nobody really is willing to integrate the fixes[3] for it.
> >>
> >> A quick search didn't seem to indicate any active user base for it.
> >> If someone happens to have a quirky _old_ card that the eleven year
> >> old "new" driver doesn't work with, then it is entirely reasonable
> >> that they stick with a kernel version that predates this removal.
> >>
> >> [1] drivers/scsi/aic7xxx_old.c: In function ‘aic7xxx_register’:
> >>    drivers/scsi/aic7xxx_old.c:7901:5: warning: case value ‘257’ not in enumerated type ‘ahc_chip’ [-Wswitch]
> >>    drivers/scsi/aic7xxx_old.c:7898:5: warning: case value ‘513’ not in enumerated type ‘ahc_chip’ [-Wswitch]
> >>    drivers/scsi/aic7xxx_old.c: In function ‘aic7xxx_load_seeprom’:
> >>    drivers/scsi/aic7xxx_old.c:8517:5: warning: case value ‘257’ not in enumerated type ‘ahc_chip’ [-Wswitch]
> >>    drivers/scsi/aic7xxx_old.c:8510:5: warning: case value ‘513’ not in enumerated type ‘ahc_chip’ [-Wswitch]
> >>
> >> [2] http://git.kernel.org/cgit/linux/kernel/git/tglx/history.git commit 44e8778c
> >>
> >> [3] https://lkml.org/lkml/2012/10/29/215
> >>
> >> Cc: Hannes Reinecke <hare@suse.de>
> >> Cc: Doug Ledford <dledford@redhat.com>
> >> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> >> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> However, if we do this we're removing support for any non-PCI based
> adapters. I personally doubt that there are any installations left
> running on (E)ISA or VLB. But we should be clear on this.

Actually, that's not true: the aic7xxx driver has support for EISA (I
know because I've got one) but not the VLB and some of the really old
cards.

> In general I'm in favour removing obsolete drivers, so

OK, so do we have any real evidence that no-one uses this driver?  Does
any distro actually compile it, for instance?

James


