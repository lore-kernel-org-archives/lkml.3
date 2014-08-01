Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaHAKjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:39:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:51773 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaHAKjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:39:04 -0400
Date: Fri, 1 Aug 2014 11:39:01 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Patrick McHardy <kaber@trash.net>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] nftables: Convert nft_hash to use generic
 rhashtable
Message-ID: <20140801103901.GC7331@casper.infradead.org>
References: <cover.1406882738.git.tgraf@suug.ch>
 <cover.1406882738.git.tgraf@suug.ch>
 <ea51f2fdfb1ce84ff109d03bf37811e4b24135c5.1406882738.git.tgraf@suug.ch>
 <970429e5-2465-40f2-998b-b82dab3debe8@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <970429e5-2465-40f2-998b-b82dab3debe8@email.android.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 at 11:17am, Patrick McHardy wrote:
> On 1. August 2014 09:52:00 GMT+01:00, Thomas Graf <tgraf@suug.ch> wrote:
> >If the set size is known in advance, the table is sized accordingly,
> >otherwise the table size will default to 64. This is a slight change
> >in behaviour as previously the default was 4 which eventually required
> >many expansion iterations.
> 
> That's assuming a sufficient number of entries will be added. I think there
> will be many cases in nftables where the number will be lower. Since
> expansion is not very expansive this number was chosen very deliberately
> and I'd prefer to keep it.
> 
> Other than that:
> 
> Acked-by: Patrick McHardy <kaber@trash.net>

OK, I will change the nft_hash default size back to 4.

I think the expansion is more expensive than it looks though as we
are potentially calling synchronize_rcu() multiple times while
holding a mutex to protect from concurrent mutations.
