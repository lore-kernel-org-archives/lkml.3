Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbaIWLIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:08:22 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45586 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaIWLIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:08:20 -0400
Message-ID: <1411470496.26859.182.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net: optimise csum_replace4()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Date: Tue, 23 Sep 2014 04:08:16 -0700
In-Reply-To: <20140923085433.09C5A1AB26A@localhost.localdomain>
References: <20140923085433.09C5A1AB26A@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 10:54 +0200, Christophe Leroy wrote:
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

Thanks Christophe, this looks good to me.

Acked-by: Eric Dumazet <edumazet@google.com>


