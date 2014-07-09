Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaGICfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:35:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55927 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGICfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:35:37 -0400
Date: Tue, 08 Jul 2014 19:35:36 -0700 (PDT)
Message-Id: <20140708.193536.1470966008910828465.davem@davemloft.net>
To: ixaphire@qrator.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip_tunnel: fix ip_tunnel_lookup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140709044759.009fdce94cf1fb2d872a4a4f@qrator.net>
References: <20140705022637.73152ff57309c468c1fdb563@qrator.net>
	<20140708.151210.1879376103263511218.davem@davemloft.net>
	<20140709044759.009fdce94cf1fb2d872a4a4f@qrator.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 19:35:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>
Date: Wed, 9 Jul 2014 04:47:59 +0400

> How I see ip_tunnel_lookup logic:
> 1) try to find exact match (and if found return this tunnel):
> tunnel.saddr == iph.daddr && tunnel.daddr == iph.saddr && key_matched()
> 2) try to find matched (local) wildcard tunnel:
> tunnel.saddr == any && tunnel.daddr == iph.saddr && key_matched()
> 3) try to find matched (remote) wildcard tunnel:
> tunnel.saddr == iph.daddr && tunnel.daddr == any && key_matched()
> (there is also a test for multicast tunnel, but let's skip it for simplicity)
> 4) try to find matched (full) wildcard tunnel:
> tunnel.saddr == any && tunnel.daddr == any && key_matched()
> 5) if nothing found return default tunnel.
> 
> According to this logic, in 4th loop (the one you quoted) we have to test that
> tunnel.daddr == any && tunnel.saddr == any. In my opinion those two new lines
> are the best way to achieve it.

Now it makes sense, thanks for explaining.

Applied and queued up for -stable, thanks again.
