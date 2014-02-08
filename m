Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaBHPEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 10:04:14 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39687 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaBHPEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 10:04:12 -0500
Message-ID: <1391871850.10160.103.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] tcp: disable auto corking by default
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        Linux Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 08 Feb 2014 07:04:10 -0800
In-Reply-To: <20140208091944.GB16336@glanzmann.de>
References: <20140206153640.GB4103@glanzmann.de>
	 <1391727771.14985.41.camel@haakon3.risingtidesystems.com>
	 <20140207051500.GB10916@glanzmann.de> <20140207075536.GB17815@glanzmann.de>
	 <1391801597.1155.28.camel@haakon3.risingtidesystems.com>
	 <20140207205142.GA8609@glanzmann.de> <20140208091828.GA16336@glanzmann.de>
	 <20140208091944.GB16336@glanzmann.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-08 at 10:19 +0100, Thomas Glanzmann wrote:
> When using auto corking with iSCSI the round trip time at least increases by
> factor 25 probably more. Other protocols are very likely also effected.
> 
> Signed-off-by: Thomas Glanzmann <thomas@glanzmann.de>
> ---
>  net/ipv4/tcp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I think there is no hurry.

We should let auto corking on during 3.14 development cycle so that we
can fix the bugs, and thing of some optimizations.

auto cork gives a strong incentive to applications to use
TCP_CORK/MSG_MORE to avoid overhead of sending multiple small segments.

In the normal case, the extra delay is something like 10 us, so if an
application is really hit by this delay, its a strong sign it could be
improved, especially if auto corking is off.

Lets wait the end of 3.14 dev cycle before considering this patch.

Don't shoot the messenger :)

Thanks !


