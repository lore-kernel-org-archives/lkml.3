Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3I3LyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:54:10 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:31602 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128Ab3I3LyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:54:08 -0400
X-IronPort-AV: E=Sophos;i="4.90,1007,1371074400"; 
   d="scan'208";a="34896121"
Date: Mon, 30 Sep 2013 13:54:06 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: "Ruslan N. Marchenko" <me@ruff.mobi>
cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [BUG] Regression in 2fdac010 drivers/net/ethernet/via/via-velocity.c:
 update napi implementation
In-Reply-To: <20130930071531.GA13037@ruff.mobi>
Message-ID: <alpine.DEB.2.02.1309301353150.2036@localhost6.localdomain6>
References: <20130930071531.GA13037@ruff.mobi>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Sep 2013, Ruslan N. Marchenko wrote:

> Hi Julia et al.,
> 
> With this commit VIA NANO board get CPU lockup in random places on any network activity.
> The error is random, most of the times dead locked CPU on boot.
> 
> After loading via-velocity module it hangs for a while and then spits kernel mesages
> about hanged tasks from varios places - like ata, rcu_preempt or network stack.
> Also, if you boot the box with network disconnected - it works, until you plug the network cable.
> 
> On some kernel builds (like ubuntu stock) behaviour varies, sometimes the box itself works,
> but network stack dies after multiple ICMPv6 skb errors, so box ends up with network disconnected.
> Reloading network susbsys helps to recover for some time (depending on how fast eth led is blinking).
> 
> Reverting the patch allows me to boot without problems even from latest Linus trunk and send this mail.

You can find the discussion and improved patch in this thread:

http://www.spinics.net/lists/netdev/msg251287.html
Bug - regression - Via velocity interface coming up freezes kernel
From: Dirk Kraft <dirk.kraft@xxxxxxxxx>
Date: Sun, 22 Sep 2013 19:28:52 +0200

julia




> 
> Regards,
> Ruslan
> 
