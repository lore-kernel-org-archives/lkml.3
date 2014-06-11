Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaFKHnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:43:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43109 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaFKHnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:43:51 -0400
Date: Wed, 11 Jun 2014 00:43:50 -0700 (PDT)
Message-Id: <20140611.004350.1837802675812645079.davem@davemloft.net>
To: ixaphire@qrator.net
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip_tunnel: fix i_key matching in ip_tunnel_find
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140608030308.77bc67a743827807737268f1@qrator.net>
References: <20140608030308.77bc67a743827807737268f1@qrator.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Jun 2014 00:43:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>
Date: Sun, 8 Jun 2014 03:03:08 +0400

> Some tunnels (though only vti as for now) can use i_key just for internal use: 
> for example vti uses it for fwmark'ing incoming packets. So raw i_key value 
> shouldn't be treated as a distinguisher for them. ip_tunnel_key_match exists for
> cases when we want to compare two ip_tunnel_parms' i_keys.
> 
> Example bug:
> ip link add type vti ikey 1 local 1.0.0.1 remote 2.0.0.2
> ip link add type vti ikey 2 local 1.0.0.1 remote 2.0.0.2
> spawned two tunnels, although it doesn't make sense.
> 
> Signed-off-by: Dmitry Popov <ixaphire@qrator.net>

Applied, thanks.
