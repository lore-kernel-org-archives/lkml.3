Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaCZTxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:53:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46408 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaCZTxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:53:04 -0400
Date: Wed, 26 Mar 2014 15:52:58 -0400 (EDT)
Message-Id: <20140326.155258.685120737486107362.davem@davemloft.net>
To: rgb@redhat.com
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        eparis@redhat.com, sgrubb@redhat.com, hadi@mojatatu.com
Subject: Re: [PATCH][v5] netlink: have netlink per-protocol bind function
 return an error code.
From: David Miller <davem@davemloft.net>
In-Reply-To: <5bf7c2b8ad25b31bb34ae00f5fe6ec7f5d653f4b.1395693533.git.rgb@redhat.com>
References: <20140324183406.GE28666@madcap2.tricolour.ca>
	<5bf7c2b8ad25b31bb34ae00f5fe6ec7f5d653f4b.1395693533.git.rgb@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Mar 2014 12:53:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>
Date: Mon, 24 Mar 2014 16:59:23 -0400

> +				if (err)
> +					if (!nlk->portid)
> +						netlink_remove(sk);
> +					for (int undo = 0; undo < i; undo++)
> +						if (nlk->netlink_unbind)
> +							nlk->netlink_unbind(undo);
> +					return err;

Take a good long stare at that code block for a while.

Looks like you forgot the braces to delineate the code block.

This also means you really haven't tested this patch :-)

Please also DO NOT declare local variables in a for() statement,
this is not c++.
