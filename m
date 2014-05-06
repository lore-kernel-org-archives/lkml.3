Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbaEFDJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:09:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35908 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaEFDJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:09:27 -0400
Date: Mon, 05 May 2014 23:09:25 -0400 (EDT)
Message-Id: <20140505.230925.403754888653633720.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 21/24] net, diet: Make packet tpacket/mmap/fanout/rings
 optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399328773-6531-22-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-22-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:09:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon,  5 May 2014 15:26:10 -0700

> From: Andi Kleen <ak@linux.intel.com>
> 
> Many DHCP clients need basic packet sockets, but they don't need
> the fancy zero copy packet capture code, like tpacket, mmap, rings,
> fanouts. This is quite substantial code, so it's worthwhile to
> make it optional
> 
> Worth nearly 10k code.
> 
>    text	   data	    bss	    dec	    hex	filename
>  952827	  71874	  25352	1050053	 1005c5	net/built-in.o-with-packet-mmap
>  943211	  71810	  25352	1040373	  fdff5	net/built-in.o-wo-packet-mmap
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Sorry, I'm not applying this either.

Small systems use packet generation and reception tools commonly, and
the only sane way to do so is with tpacket.
