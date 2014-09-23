Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbaIWLK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:10:56 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53231 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbaIWLKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:10:54 -0400
Message-ID: <1411470654.26859.183.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net: optimise inet_proto_csum_replace4()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Date: Tue, 23 Sep 2014 04:10:54 -0700
In-Reply-To: <20140923085437.696B81AB26D@localhost.localdomain>
References: <20140923085437.696B81AB26D@localhost.localdomain>
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
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !


