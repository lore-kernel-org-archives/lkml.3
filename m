Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaIZUOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:14:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50790 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaIZUOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:14:38 -0400
Date: Fri, 26 Sep 2014 16:14:36 -0400 (EDT)
Message-Id: <20140926.161436.2294622951811354901.davem@davemloft.net>
To: christophe.leroy@c-s.fr
Cc: linux-kernel@vger.kernel.org, edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: optimise csum_replace4()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140923085433.09C5A1AB26A@localhost.localdomain>
References: <20140923085433.09C5A1AB26A@localhost.localdomain>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Sep 2014 13:14:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Tue, 23 Sep 2014 10:54:32 +0200 (CEST)

> csum_partial() is a generic function which is not optimised for small fixed
> length calculations, and its use requires to store "from" and "to" values in
> memory while we already have them available in registers. This also has impact,
> especially on RISC processors. In the same spirit as the change done by
> Eric Dumazet on csum_replace2(), this patch rewrites inet_proto_csum_replace4()
> taking into account RFC1624.
> 
> I spotted during a NATted tcp transfert that csum_partial() is one of top 5
> consuming functions (around 8%), and the second user of csum_partial() is 
> inet_proto_csum_replace4().
> 
> I have proposed the same modification to inet_proto_csum_replace4() in another
> patch.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Applied.
