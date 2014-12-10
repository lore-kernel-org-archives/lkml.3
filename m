Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaLJKKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:10:22 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:9940 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaLJKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:10:21 -0500
Date: Wed, 10 Dec 2014 15:44:01 +0530
From: Hariprasad S <hariprasad@chelsio.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20141210101359.GA3891@hariprasad-pc>
References: <20141210195405.5af40846@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141210195405.5af40846@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.193.190.82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 19:54:05 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/ethernet/chelsio/cxgb4vf/built-in.o:(.opd+0x630): multiple definition of `t4_bar2_sge_qregs'
> drivers/net/ethernet/chelsio/cxgb4/built-in.o:(.opd+0x14d0): first defined here
> drivers/net/ethernet/chelsio/cxgb4vf/built-in.o: In function `.t4_bar2_sge_qregs':
> (.text+0x9220): multiple definition of `.t4_bar2_sge_qregs'
> drivers/net/ethernet/chelsio/cxgb4/built-in.o:(.text+0x24e24): first defined here
> 
> Caused by commit e85c9a7abfa4 ("cxgb4/cxgb4vf: Add code to calculate T5
> BAR2 Offsets for SGE Queue Registers") which added both versions.  :-(
> 
> I have applied this fir patch for today (including the subject
> typo :-)):
> 
My bad. Thanks for the fix.
