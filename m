Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbbAELgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:36:25 -0500
Received: from mail.us.es ([193.147.175.20]:58119 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbbAELgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:36:22 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.5/19880. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 1.812515 secs); 05 Jan 2015 11:36:20 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Mon, 5 Jan 2015 12:39:07 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: "David S. Miller" <davem@davemloft.net>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] nftables: nft_flush_table: handle chain dependencies
Message-ID: <20150105113907.GA15161@salvia>
References: <1419634318-18303-1-git-send-email-asbjorn@asbjorn.biz>
 <1419640765-7707-1-git-send-email-asbjorn@asbjorn.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419640765-7707-1-git-send-email-asbjorn@asbjorn.biz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 12:39:25AM +0000, Asbjoern Sloth Toennesen wrote:
> Update: I errously assumed that git add, while writing the commit
> message, would be added to the commit.
> Based on net-next f96fe225. Compiles and checkpatch clean.
> 
> Jumping between chains doesn't mix well with flush ruleset,
> since nft_flush_table doesn't handle chains referencing chains.
> 
> This way it will take one to two loops, to settle.
> Alternatively it can be solved by always having two loops,

I just sent you a different patch to address this, we may still have
references from the elements to chains when using dictionaries, so I
prefer to schedule the object release in this order:

rules -> sets -> chains -> tables

Thanks for diagnosing and sending an initial fix.

P.S: I hope you enjoyed 31c3.
