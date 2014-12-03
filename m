Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaLCDVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:21:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55940 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaLCDVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:21:09 -0500
Date: Tue, 02 Dec 2014 19:25:30 -0800 (PST)
Message-Id: <20141202.192530.460426718376541462.davem@davemloft.net>
To: seth.forshee@canonical.com
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, zoltan.kiss@linaro.org,
        eric.dumazet@gmail.com, stefan.bader@canonical.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-netfront: Remove BUGs on paged skb data which
 crosses a page boundary
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416968904-70874-1-git-send-email-seth.forshee@canonical.com>
References: <1416968904-70874-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Dec 2014 19:21:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>
Date: Tue, 25 Nov 2014 20:28:24 -0600

> These BUGs can be erroneously triggered by frags which refer to
> tail pages within a compound page. The data in these pages may
> overrun the hardware page while still being contained within the
> compound page, but since compound_order() evaluates to 0 for tail
> pages the assertion fails. The code already iterates through
> subsequent pages correctly in this scenario, so the BUGs are
> unnecessary and can be removed.
> 
> Fixes: f36c374782e4 ("xen/netfront: handle compound page fragments on transmit")
> Cc: <stable@vger.kernel.org> # 3.7+
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Applied, thanks.
