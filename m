Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaJUHEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 03:04:32 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:48691 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaJUHEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:04:31 -0400
Date: Tue, 21 Oct 2014 09:04:24 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, paulmck@linux.vnet.ibm.com,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ursula Braun <braunu@de.ibm.com>
Subject: Re: [PATCH] netlink: Re-add locking to netlink_lookup() and seq
 walker
Message-ID: <20141021070424.GA4161@osiris>
References: <20141011083627.GB5074@osiris>
 <1413055964.9362.50.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141011222514.GA14186@casper.infradead.org>
 <20141020082107.GB4268@osiris>
 <20141020195355.GA2299@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020195355.GA2299@casper.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102107-0025-0000-0000-000001FB648A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 08:53:55PM +0100, Thomas Graf wrote:
> Heiko,
> 
> Can you test the following patch:
> 
> The synchronize_rcu() in netlink_release() introduces unacceptable
> latency. Reintroduce minimal lookup so we can drop the
> synchronize_rcu() until socket destruction has been RCUfied.
> 
> Signed-off-by: Thomas Graf <tgraf@suug.ch>
> ---
>  net/netlink/af_netlink.c | 37 +++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)

Thanks a lot! Your patch fixes the issue for me.

Reported-and-tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>

