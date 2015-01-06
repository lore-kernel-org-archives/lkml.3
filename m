Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbbAFWTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:19:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56296 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbbAFWTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:19:44 -0500
Date: Tue, 06 Jan 2015 17:19:41 -0500 (EST)
Message-Id: <20150106.171941.296781199194329785.davem@davemloft.net>
To: stephen@networkplumber.org
Cc: tgraf@suug.ch, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, paulmck@linux.vnet.ibm.com,
        edumazet@google.com, john.r.fastabend@intel.com, josh@joshtriplett.org
Subject: Re: [RFC] netlink: get rid of nl_table_lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20150103110211.18b11f0f@urahara>
References: <cover.1420230585.git.tgraf@suug.ch>
	<daae84cd33bfde8518b849176e25dcf3eea8014b.1420230585.git.tgraf@suug.ch>
	<20150103110211.18b11f0f@urahara>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 14:19:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Sat, 3 Jan 2015 11:02:11 -0800

> As a follow on to Thomas's patch I think this would complete the
> transistion to RCU for netlink.
> Compile tested only.
> 
> This patch gets rid of the reader/writer nl_table_lock and replaces it
> with exclusively using RCU for reading, and a mutex for writing.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

FWIW, this approach looks fine to me.

Thomas can you review this?
