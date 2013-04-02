Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab3DBXw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:52:27 -0400
Received: from mail.openmoko.org ([88.198.124.205]:35794 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab3DBXw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:52:26 -0400
X-Greylist: delayed 2283 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 19:52:25 EDT
Date: Tue, 2 Apr 2013 20:13:19 -0300
From: Werner Almesberger <werner@almesberger.net>
To: Alan Ott <alan@signal11.us>
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel <linux-zigbee-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-zigbee-devel] [PATCH 1/6] mac802154: Immediately retry
 sending failed packets
Message-ID: <20130402231319.GD28141@ws>
References: <1364928481-1813-1-git-send-email-alan@signal11.us>
 <1364928481-1813-2-git-send-email-alan@signal11.us>
 <CAJmB2rCr5ds11+iN=W5GCKsUgdfb57uKg+mH4NY4CWw6EFCTbg@mail.gmail.com>
 <515B3F78.2020301@signal11.us>
 <515B4D79.40805@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515B4D79.40805@signal11.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Ott wrote:
> it's now my opinion that we should _not_ try to retransmit at
> all in mac802154/tx.c.

I think the currently blocking workqueue design is ugly and
quite contrary to how most the rest of the stack works. So
anything that kills it has my blessing :-)

I do wonder though why it was done like this in the first place.
Just for convenience ?

If we want to move towards an asynchronous interface, it could
exist in parallel with the current one. That way, drivers could
be migrated one by one.

Having said that, the errors you get there may not be failed
single transmissions on the air but some form of congestion in
the driver or a problem with the device. But I don't think
that's a valid reason for retrying the transmission at that
level.

- Werner
