Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaIPU30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:29:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57954 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbaIPU3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:29:25 -0400
Date: Tue, 16 Sep 2014 16:29:23 -0400 (EDT)
Message-Id: <20140916.162923.605101746131407931.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: mroos@linux.ee, klassert@mathematik.tu-chemnitz.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: bisected regression: 3c59x corrupts packets in 3.17-rc5
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140916101704.GA3792@hmsreliant.think-freely.org>
References: <alpine.LRH.2.11.1409160209280.21050@adalberg.ut.ee>
	<20140916101704.GA3792@hmsreliant.think-freely.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Sep 2014 13:29:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 16 Sep 2014 06:17:04 -0400

> I'm guessing the above change has uncovered another bug,

Neil, read your patch carefully, I think it added the bug.

The ->page_offset of the frag gets applied two times.

skb_dma_map_frag() already takes frag->page_offset into consideration,
you then pass it in as the 'offset' argument and it then gets added to
itself to compute th final offset.
