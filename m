Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbbAFW3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:29:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56521 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbbAFW3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:29:22 -0500
Date: Tue, 06 Jan 2015 17:29:18 -0500 (EST)
Message-Id: <20150106.172918.70204012105519766.davem@davemloft.net>
To: amirv@mellanox.com
Cc: ddecotig@gmail.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        saeedm@mellanox.com, decot@googlers.com, jasowang@redhat.com,
        mst@redhat.com, herbert@gondor.apana.org.au, viro@zeniv.linux.org.uk,
        ben@decadent.org.uk, yamato@redhat.com, xii@google.com,
        nhorman@tuxdriver.com, xiyou.wangcong@gmail.com, fbl@redhat.com,
        teg@jklm.no, jiri@resnulli.us, vyasevic@redhat.com,
        ebiederm@xmission.com, VenkatKumar.Duvvuru@Emulex.Com, _govind@gmx.com
Subject: Re: [PATCH net-next v2 0/8] net: extend ethtool link mode bitmaps
 to 48 bits
From: David Miller <davem@davemloft.net>
In-Reply-To: <54ABE991.3040107@mellanox.com>
References: <1420512850-24699-1-git-send-email-ddecotig@gmail.com>
	<54ABE991.3040107@mellanox.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 14:29:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Vadai <amirv@mellanox.com>
Date: Tue, 6 Jan 2015 15:56:33 +0200

> Mellanox is about to release next month a driver for a new NIC, with 3
> new speeds * few link modes for each + new link modes for 10G.
> It seems that we will need to consume almost all the new bits.

This tells me that the approach to this problem needs to be rethought.

Maybe we just need to bite the bullet and make a new ETHTOOL_GSET_2
and ETHTOOL_SSET_2 or whatever you want to name them.

Then we can define a completely new structure, with 64-bit bitmaps
for link modes or whatever.  The ethtool_op callbacks work using
this structure, and only the net/core/ethtool.c code knows about
the older structure and translates to/from for ETHTOOL_{GSET,SSET}.
