Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3I3H0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 03:26:33 -0400
Received: from vex.ruff.mobi ([46.167.245.136]:55286 "EHLO vex.ruff.mobi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab3I3H0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 03:26:31 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2013 03:26:31 EDT
Date: Mon, 30 Sep 2013 09:15:31 +0200
From: "Ruslan N. Marchenko" <me@ruff.mobi>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [BUG] Regression in 2fdac010
 drivers/net/ethernet/via/via-velocity.c: update napi implementation
Message-ID: <20130930071531.GA13037@ruff.mobi>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Julia Lawall <Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia et al.,

With this commit VIA NANO board get CPU lockup in random places on any network activity.
The error is random, most of the times dead locked CPU on boot.

After loading via-velocity module it hangs for a while and then spits kernel mesages
about hanged tasks from varios places - like ata, rcu_preempt or network stack.
Also, if you boot the box with network disconnected - it works, until you plug the network cable.

On some kernel builds (like ubuntu stock) behaviour varies, sometimes the box itself works,
but network stack dies after multiple ICMPv6 skb errors, so box ends up with network disconnected.
Reloading network susbsys helps to recover for some time (depending on how fast eth led is blinking).

Reverting the patch allows me to boot without problems even from latest Linus trunk and send this mail.

Regards,
Ruslan
