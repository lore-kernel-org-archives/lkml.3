Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3K3R1v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 12:27:51 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30031 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490Ab3K3R1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 12:27:49 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+u3C67OxcPb98eAEpZNnRo
Date: Sat, 30 Nov 2013 09:27:40 -0800
From: Tony Lindgren <tony@atomide.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        pali.rohar@gmail.com, sre@ring0.de, pavel@ucw.cz,
        omar.ramirez@copitl.com, felipe.contreras@gmail.com, s-anna@ti.com,
        nm@ti.com, ohad@wizery.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Staging: tidspbridge: disable driver
Message-ID: <20131130172739.GE23334@atomide.com>
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
 <20131130162023.GB15077@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131130162023.GB15077@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@linuxfoundation.org> [131130 08:20]:
> On Sat, Nov 30, 2013 at 11:58:23AM +0200, Ivajlo Dimitrov wrote:
> > Hi,
> > 
> > (re-sending in plain text, sorry for the noise)
> > 
> > commit 
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=930ba4a374b96560ef9fde2145cdc454a164ddcc
> > disables tidspbridge driver for the reasons it has a security bug and there 
> > is no active maintainer.
> > I was following the development of that driver for a bit and my impression 
> > was that the reason it is
> > still in staging is this 
> > http://www.spinics.net/lists/linux-omap/msg84115.html . And as dmtimer
> > driver is on its way to be merged upstream(or was it already merged?)  I was 
> > planning to work on
> > tidspbridge driver to fix it and send the patches. I also have a couple of 
> > another small patches
> > ready to be send.

I'd rather not just export 27 omap specific functions for the dmtimer to the
drivers knowing what kind of mess it will be.. There's some work happening
to make the dmtimer more generic, so for those parts we should have a solution
soonish.

> > However, could you elaborate on the "security bug" so I can try to fix it 
> > and send the patch?
> > Also, what needs to be done for the tidspdriver to get out of staging as it 
> > seems that what I
> > though initially is incorrect.
> 
> There is also the very long TODO list in drivers/staging/tidspbridge/
> 
> What is the progression on that?

Yeah and the tidspbridge should use the remoteproc which seems to be missing
from the TODO file. Anyways, the pending dmtimer work should not impact fixing
the other issues from development point of view.

Regards,

Tony
