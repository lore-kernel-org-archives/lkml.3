Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbbAMF0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:26:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57411 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbbAMF0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:26:04 -0500
Date: Tue, 13 Jan 2015 00:25:39 -0500 (EST)
Message-Id: <20150113.002539.865888654705925013.davem@davemloft.net>
To: tgraf@suug.ch
Cc: fengguang.wu@intel.com, lkp@01.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] rhashtable: Lower/upper bucket may map to
 same lock while shrinking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20150112235821.GB16617@casper.infradead.org>
References: <20150112232217.GA5277@wfg-t540p.sh.intel.com>
	<20150112235821.GB16617@casper.infradead.org>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Jan 2015 21:26:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Mon, 12 Jan 2015 23:58:21 +0000

> Each per bucket lock covers a configurable number of buckets. While
> shrinking, two buckets in the old table contain entries for a single
> bucket in the new table. We need to lock down both while linking.
> Check if they are protected by different locks to avoid a recursive
> lock.
> 
> Fixes: 97defe1e ("rhashtable: Per bucket locks & deferred expansion/shrinking")
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Thomas Graf <tgraf@suug.ch>

Applied.
