Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbbASTRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:17:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:32823 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbbASTRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:17:00 -0500
Date: Mon, 19 Jan 2015 14:16:53 -0500 (EST)
Message-Id: <20150119.141653.1430392722084939705.davem@davemloft.net>
To: nicolas.dichtel@6wind.com
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        ebiederm@xmission.com, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net, cwang@twopensource.com
Subject: Re: [PATCH net-next v5 0/4] netns: allow to identify peer netns
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421331078-21622-1-git-send-email-nicolas.dichtel@6wind.com>
References: <87wq7g831b.fsf@x220.int.ebiederm.org>
	<1421331078-21622-1-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Jan 2015 11:16:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Thu, 15 Jan 2015 15:11:14 +0100

> The goal of this serie is to be able to multicast netlink messages with an
> attribute that identify a peer netns.
> This is needed by the userland to interpret some information contained in
> netlink messages (like IFLA_LINK value, but also some other attributes in case
> of x-netns netdevice (see also
> http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).
> 
> Ids of peer netns can be set by userland via a new rtnl cmd RTM_NEWNSID. When
> the kernel needs an id for a peer (for example when advertising a new x-netns
> interface via netlink), if the user didn't allocate an id, one will be
> automatically allocated.
> These ids are stored per netns and are local (ie only valid in the netns where
> they are set). To avoid allocating an int for each peer netns, I use
> idr_for_each() to retrieve the id of a peer netns. Note that it will be possible
> to add a table (struct net -> id) later to optimize this lookup if needed.
> 
> Patch 1/4 introduces the rtnetlink API mechanism to set and get these ids.
> Patch 2/4 and 3/4 implements an example of how to use these ids when advertising
> information about a x-netns interface.
> And patch 4/4 shows that the netlink messages can be symetric between a GET and
> a SET.
 ...

Seires applied, thanks.
