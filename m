Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3KNUsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:48:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab3KNUsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:48:13 -0500
Date: Thu, 14 Nov 2013 15:47:59 -0500
From: Jay Fenlason <fenlason@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: johunt@akamai.com, netdev@vger.kernel.org, venkat.x.venkatsubra@oracle.com,
        linux-kernel@vger.kernel.org, jjolly@suse.com, honli@redhat.com
Subject: Re: [PATCH] rds: fix local ping DoS
Message-ID: <20131114204758.GA22417@redhat.com>
References: <1384391743-9342-1-git-send-email-johunt@akamai.com>
 <20131114.020355.1973894145326845195.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114.020355.1973894145326845195.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 02:03:55AM -0500, David Miller wrote:
> From: Josh Hunt <johunt@akamai.com>
> Date: Wed, 13 Nov 2013 17:15:43 -0800
> 
> > The rds_ib_xmit function in net/rds/ib_send.c in the Reliable Datagram Sockets
> > (RDS) protocol implementation allows local users to cause a denial of service
> > (BUG_ON and kernel panic) by establishing an RDS connection with the source
> > IP address equal to the IPoIB interface's own IP address, as demonstrated by
> > rds-ping.
> > 
> > A local unprivileged user could use this flaw to crash the system.
> > 
> > CVE-2012-2372
> > 
> > Reported-by: Honggang Li <honli@redhat.com>
> > Signed-off-by: Josh Hunt <johunt@akamai.com>
> 
> I'm sorry I can't apply this.  This commit message needs to be much
> less terse and explain things more.
> 
> First of all, why is the "off % RDS_FRAG_SIZE" important?
> 
> And, even more importantly, why is is OK to avoid this assertion just
> because we're going over loopback?
> 
> Furthermore, why doesn't net/rds/iw_send.c:rds_iw_xmit() have the same
> exact problem?  It makes the same exact assertion check.
> 
> I know this RDS code is a steaming pile of poo, but that doesn't mean
> we just randomly adjust assertions to make crashes go away without
> sufficient understanding of exactly what's going on.

And that is why rds should be moved to staging, where nobody will
accidentally think that it is actually being maintained.

			-- JF
