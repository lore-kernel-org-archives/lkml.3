Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaBHQzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:55:43 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:60952 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaBHQzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:55:41 -0500
Date: Sat, 8 Feb 2014 17:55:39 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tcp: disable auto corking by default
Message-ID: <20140208165539.GA22359@glanzmann.de>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	target-devel <target-devel@vger.kernel.org>,
	Linux Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140206153640.GB4103@glanzmann.de>
 <1391727771.14985.41.camel@haakon3.risingtidesystems.com>
 <20140207051500.GB10916@glanzmann.de>
 <20140207075536.GB17815@glanzmann.de>
 <1391801597.1155.28.camel@haakon3.risingtidesystems.com>
 <20140207205142.GA8609@glanzmann.de>
 <20140208091828.GA16336@glanzmann.de>
 <20140208091944.GB16336@glanzmann.de>
 <1391871850.10160.103.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391871850.10160.103.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

> > Disable auto corking by default

> We should let auto corking on during 3.14 development cycle so that we
> can fix the bugs, and thing of some optimizations.

I agree that leaving it enabled helps to find bugs, however I'm not
happy with the round trip time degradation.

> auto cork gives a strong incentive to applications to use
> TCP_CORK/MSG_MORE to avoid overhead of sending multiple small
> segments.

I agree. But if it breaks the application many people won't be happy,
for example I spend already 5 hours to track it down.

> In the normal case, the extra delay is something like 10 us, so if an
> application is really hit by this delay, its a strong sign it could be
> improved, especially if auto corking is off.

Yes, but 230 micro seconds for others. :-(

> Lets wait the end of 3.14 dev cycle before considering this patch.

I agree.

Btw. I mixed up the pcaps for autocork on and off, so I moved the files
that they know show what they should show.

Cheers,
        Thomas
