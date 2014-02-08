Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaBHRMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 12:12:42 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:41118 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaBHRMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 12:12:40 -0500
Message-ID: <1391879558.10160.112.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] tcp: disable auto corking by default
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 08 Feb 2014 09:12:38 -0800
In-Reply-To: <20140208165539.GA22359@glanzmann.de>
References: <20140206153640.GB4103@glanzmann.de>
	 <1391727771.14985.41.camel@haakon3.risingtidesystems.com>
	 <20140207051500.GB10916@glanzmann.de> <20140207075536.GB17815@glanzmann.de>
	 <1391801597.1155.28.camel@haakon3.risingtidesystems.com>
	 <20140207205142.GA8609@glanzmann.de> <20140208091828.GA16336@glanzmann.de>
	 <20140208091944.GB16336@glanzmann.de>
	 <1391871850.10160.103.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140208165539.GA22359@glanzmann.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-08 at 17:55 +0100, Thomas Glanzmann wrote:
> Hello Eric,
> 
> > > Disable auto corking by default
> 
> > We should let auto corking on during 3.14 development cycle so that we
> > can fix the bugs, and thing of some optimizations.
> 
> I agree that leaving it enabled helps to find bugs, however I'm not
> happy with the round trip time degradation.
> 
> > auto cork gives a strong incentive to applications to use
> > TCP_CORK/MSG_MORE to avoid overhead of sending multiple small
> > segments.
> 
> I agree. But if it breaks the application many people won't be happy,
> for example I spend already 5 hours to track it down.

Sure, but if we put this flag to zero, nobody will ever use it and find
any bug.

Thanks for running latest git tree and be part of linux improvement.

If we can add the MSG_MORE at the right place, your workload might gain
~20% exec time, and maybe 30% better efficiency, since you'll divide by
2 the total number of network segments.

Just to be clear : No stable kernel has yet any issue, right ?



