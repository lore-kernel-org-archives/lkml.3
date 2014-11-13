Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213AbaKMUS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:18:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59186 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296AbaKMUS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:18:57 -0500
Date: Thu, 13 Nov 2014 15:18:53 -0500 (EST)
Message-Id: <20141113.151853.1944374659110428712.davem@davemloft.net>
To: tgraf@suug.ch
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] rhashtable: Drop gfp_flags arg in
 insert/remove functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <17c3262027e643a0826c6ac5dd2d14cda0822a0b.1415879747.git.tgraf@suug.ch>
References: <17c3262027e643a0826c6ac5dd2d14cda0822a0b.1415879747.git.tgraf@suug.ch>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Nov 2014 12:18:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Thu, 13 Nov 2014 13:45:46 +0100

> Reallocation is only required for shrinking and expanding and both rely
> on a mutex for synchronization and callers of rhashtable_init() are in
> non atomic context. Therefore, no reason to continue passing allocation
> hints through the API.
> 
> Instead, use GFP_KERNEL and add __GFP_NOWARN | __GFP_NORETRY to allow
> for silent fall back to vzalloc() without the OOM killer jumping in as
> pointed out by Eric Dumazet and Eric W. Biederman.
> 
> Signed-off-by: Thomas Graf <tgraf@suug.ch>

Applied, thanks Thomas.
