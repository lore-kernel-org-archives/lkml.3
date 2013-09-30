Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3I3Lnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:43:39 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:36011 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413Ab3I3Lni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:43:38 -0400
X-IronPort-AV: E=Sophos;i="4.90,1007,1371074400"; 
   d="scan'208";a="34894455"
Date: Mon, 30 Sep 2013 13:43:35 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: "Ruslan N. Marchenko" <me@ruff.mobi>
cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Regression in 2fdac010 drivers/net/ethernet/via/via-velocity.c:
 update napi implementation
In-Reply-To: <20130930071531.GA13037@ruff.mobi>
Message-ID: <alpine.DEB.2.02.1309301342530.2036@localhost6.localdomain6>
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

There has already been a discussion about this, and a patch has already 
been proposed.  It has to do with lock managament.  I will look for the 
email.

julia
