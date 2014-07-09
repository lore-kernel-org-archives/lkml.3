Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaGIDtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:49:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56238 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaGIDtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:49:16 -0400
Date: Tue, 08 Jul 2014 20:49:15 -0700 (PDT)
Message-Id: <20140708.204915.1577238573149775056.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: wei.liu2@citrix.com, Ian.Campbell@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next v4] xen-netback: Adding debugfs "io_ring_qX"
 files
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404845354-16237-1-git-send-email-zoltan.kiss@citrix.com>
References: <1404845354-16237-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 20:49:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Tue, 8 Jul 2014 19:49:14 +0100

> This patch adds debugfs capabilities to netback. There used to be a similar
> patch floating around for classic kernel, but it used procfs. It is based on a
> very similar blkback patch.
> It creates xen-netback/[vifname]/io_ring_q[queueno] files, reading them output
> various ring variables etc. Writing "kick" into it imitates an interrupt
> happened, it can be useful to check whether the ring is just stalled due to a
> missed interrupt.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

Applied, but like others I consider those ifdefs hella ugly.

Provide stubs in an #else block, then you don't have to crap up the
main code.
