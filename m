Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3EFOiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:38:03 -0400
Received: from tex.lwn.net ([70.33.254.29]:46270 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab3EFOiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:38:01 -0400
Date: Mon, 6 May 2013 08:37:59 -0600
From: Jake Edge <jake@lwn.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
Message-ID: <20130506083759.556dac76@chukar.edge2.net>
In-Reply-To: <20130506123805.GA1602@redhat.com>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
	<20130506123805.GA1602@redhat.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.16; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013 14:38:06 +0200 Stanislaw Gruszka wrote:

> > I bisected the problem to:
> > 
> > commit 1672c0e31917f49d31d30d79067103432bc20cc7

> > What more information is needed from me?  I may still mess around
> > with trying to revert that patch just to nail it down for sure, but
> > two separate bisection exercises ended up at the same place.
> 
> Below patch should restore old mac80211 behaviour, by stop
> telling mac that 4965 supports TX ACK status. Does it help?

Yup, that fixed the problem, thanks.  So did reverting Johannes's
commit above, fwiw, but just turning off that flag in 3.9 as your patch
does fixes it.

seems like that needs to head to Linus and the stable folks ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
