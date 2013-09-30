Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab3I3Nye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:54:34 -0400
Received: from vex.ruff.mobi ([46.167.245.136]:55788 "EHLO vex.ruff.mobi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab3I3Nyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:54:33 -0400
Date: Mon, 30 Sep 2013 15:54:27 +0200
From: "Ruslan N. Marchenko" <me@ruff.mobi>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Regression in 2fdac010
 drivers/net/ethernet/via/via-velocity.c: update napi implementation
Message-ID: <20130930135427.GA19660@ruff.mobi>
Mail-Followup-To: Julia Lawall <julia.lawall@lip6.fr>,
	linux-kernel@vger.kernel.org
References: <20130930071531.GA13037@ruff.mobi>
 <alpine.DEB.2.02.1309301353150.2036@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309301353150.2036@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 01:54:06PM +0200, Julia Lawall wrote:
> On Mon, 30 Sep 2013, Ruslan N. Marchenko wrote:
> 
> > Hi Julia et al.,
> > 
> > With this commit VIA NANO board get CPU lockup in random places on any network activity.
> > The error is random, most of the times dead locked CPU on boot.
> > 
> > After loading via-velocity module it hangs for a while and then spits kernel mesages
> > about hanged tasks from varios places - like ata, rcu_preempt or network stack.
> > Also, if you boot the box with network disconnected - it works, until you plug the network cable.
> > 
> > On some kernel builds (like ubuntu stock) behaviour varies, sometimes the box itself works,
> > but network stack dies after multiple ICMPv6 skb errors, so box ends up with network disconnected.
> > Reloading network susbsys helps to recover for some time (depending on how fast eth led is blinking).
> > 
> > Reverting the patch allows me to boot without problems even from latest Linus trunk and send this mail.
> 
> You can find the discussion and improved patch in this thread:
> 
> http://www.spinics.net/lists/netdev/msg251287.html
> Bug - regression - Via velocity interface coming up freezes kernel
> From: Dirk Kraft <dirk.kraft@xxxxxxxxx>
> Date: Sun, 22 Sep 2013 19:28:52 +0200
> 
> julia

Oops, sorry, somehow I missed it even though 've been searching for via-velocity regression.
Will give a try to new proposed patch as well.

Thanks,
Ruslan 
