Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaICF2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:28:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34109 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaICF2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:28:23 -0400
Date: Tue, 02 Sep 2014 22:28:19 -0700 (PDT)
Message-Id: <20140902.222819.1246875721008896036.davem@davemloft.net>
To: harish_kandiga@mentor.com
Cc: dborkman@redhat.com, tgraf@suug.ch, ebiederm@xmission.com,
        darkjames-ws@darkjames.pl, rgb@redhat.com, eric.dumazet@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] netlink: Safer deletion of sk_bind_node
From: David Miller <davem@davemloft.net>
In-Reply-To: <5406A4FF.1090209@mentor.com>
References: <54058376.9090700@mentor.com>
	<20140902.115215.1488500321662046816.davem@davemloft.net>
	<5406A4FF.1090209@mentor.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Sep 2014 22:28:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harish Jenny Kandiga Nagaraj <harish_kandiga@mentor.com>
Date: Wed, 3 Sep 2014 10:49:59 +0530

> If that is the case , then subscriptions of netlink_sock should have
> been updated after netlink_remove or netlink_release.  I don't see
> that happening.

Please do not top-post.  First provide the quoted context, then provide
your response afterwards, rather than the other way around.

The point I was trying to make is that all code paths that operate
on this list have to follow this rule, if there is a code path that
is not then that is your bug and that is where the fix belongs.

We're unexpectedly having double deletes occur on this list, I would
prefer if we don't paper over it by allowing it to silently succeed.
