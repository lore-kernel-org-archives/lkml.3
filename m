Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaFKGg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 02:36:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42773 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaFKGgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 02:36:25 -0400
Date: Tue, 10 Jun 2014 23:36:24 -0700 (PDT)
Message-Id: <20140610.233624.23993271628864053.davem@davemloft.net>
To: ixaphire@qrator.net
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] ipip, sit: fix ipv4_{update_pmtu,redirect} calls
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140606231921.2ff39106ac54216fd9170fae@qrator.net>
References: <20140606231921.2ff39106ac54216fd9170fae@qrator.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Jun 2014 23:36:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>
Date: Fri, 6 Jun 2014 23:19:21 +0400

> ipv4_{update_pmtu,redirect} were called with tunnel's ifindex (t->dev is a 
> tunnel netdevice). It caused wrong route lookup and failure of pmtu update or 
> redirect. We should use the same ifindex that we use in ip_route_output_* in 
> *tunnel_xmit code. It is t->parms.link .
> 
> Signed-off-by: Dmitry Popov <ixaphire@qrator.net>

Applied and queued up for -stable, thanks.
