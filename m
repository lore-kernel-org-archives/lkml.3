Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbaCSDLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 23:11:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58166 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241AbaCSDLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 23:11:31 -0400
Date: Tue, 18 Mar 2014 23:11:29 -0400 (EDT)
Message-Id: <20140318.231129.458845509074325949.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140317212100.9b57a2237439427be566ede7@canb.auug.org.au>
References: <20140317212100.9b57a2237439427be566ede7@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Mar 2014 20:11:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 17 Mar 2014 21:21:00 +1100

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/ethernet/intel/i40evf/built-in.o:(.data+0x1868): multiple definition of `i40e_ptype_lookup'
> drivers/net/ethernet/intel/i40e/built-in.o:(.data+0x3f58): first defined here
> 
> Caused by commit 206812b5fccb ("i40e/i40evf: i40e implementation for
> skb_set_hash") from the net-next tree.
> 
> I applied this patch for today (there is probably a better way):
> 
> From 6964d39f8436eade2cdb0c5236734c579b8b0897 Mon Sep 17 00:00:00 2001
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 17 Mar 2014 21:18:48 +1100
> Subject: [PATCH] i40e/i40evf: i40e implementation for skb_set_hash fix
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Jeff Kirsher gave me a patch today that fixes this, thanks Stephen.
