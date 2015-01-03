Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbbACTpD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 14:45:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44210 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbACTpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 14:45:00 -0500
Date: Sat, 03 Jan 2015 14:44:55 -0500 (EST)
Message-Id: <20150103.144455.345230130702474137.davem@davemloft.net>
To: tgraf@suug.ch
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, paulmck@linux.vnet.ibm.com,
        edumazet@google.com, john.r.fastabend@intel.com, josh@joshtriplett.org
Subject: Re: [PATCH 0/9 net-next v2] rhashtable: Per bucket locks &
 deferred table resizing
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1420230585.git.tgraf@suug.ch>
References: <cover.1420230585.git.tgraf@suug.ch>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 03 Jan 2015 11:44:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Fri,  2 Jan 2015 23:00:13 +0100

> Prepares for and introduces per bucket spinlocks and deferred table
> resizing. This allows for parallel table mutations in different hash
> buckets from atomic context. The resizing occurs in the background
> in a separate worker thread while lookups, inserts, and removals can
> continue.
> 
> Also modified the chain linked list to be terminated with a special
> nulls marker to allow entries to move between multiple lists.
> 
> Last but not least, reintroduces lockless netlink_lookup() with
> deferred Netlink socket destruction to avoid the side effect of
> increased netlink_release() runtime.

I'm sure that this might need a minor tweak or two still, but I really
like how you implemented this so I'll apply this series now.

Thanks!
