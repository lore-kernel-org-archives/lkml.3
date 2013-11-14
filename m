Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3KNHEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 02:04:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48003 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3KNHD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 02:03:57 -0500
Date: Thu, 14 Nov 2013 02:03:55 -0500 (EST)
Message-Id: <20131114.020355.1973894145326845195.davem@davemloft.net>
To: johunt@akamai.com
Cc: netdev@vger.kernel.org, venkat.x.venkatsubra@oracle.com,
        linux-kernel@vger.kernel.org, jjolly@suse.com, fenlason@redhat.com,
        honli@redhat.com
Subject: Re: [PATCH] rds: fix local ping DoS
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384391743-9342-1-git-send-email-johunt@akamai.com>
References: <1384391743-9342-1-git-send-email-johunt@akamai.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 13 Nov 2013 23:03:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>
Date: Wed, 13 Nov 2013 17:15:43 -0800

> The rds_ib_xmit function in net/rds/ib_send.c in the Reliable Datagram Sockets
> (RDS) protocol implementation allows local users to cause a denial of service
> (BUG_ON and kernel panic) by establishing an RDS connection with the source
> IP address equal to the IPoIB interface's own IP address, as demonstrated by
> rds-ping.
> 
> A local unprivileged user could use this flaw to crash the system.
> 
> CVE-2012-2372
> 
> Reported-by: Honggang Li <honli@redhat.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>

I'm sorry I can't apply this.  This commit message needs to be much
less terse and explain things more.

First of all, why is the "off % RDS_FRAG_SIZE" important?

And, even more importantly, why is is OK to avoid this assertion just
because we're going over loopback?

Furthermore, why doesn't net/rds/iw_send.c:rds_iw_xmit() have the same
exact problem?  It makes the same exact assertion check.

I know this RDS code is a steaming pile of poo, but that doesn't mean
we just randomly adjust assertions to make crashes go away without
sufficient understanding of exactly what's going on.

Thanks.
