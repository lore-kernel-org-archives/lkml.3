Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaHZAqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:46:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40056 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbaHZAqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:46:54 -0400
Date: Mon, 25 Aug 2014 17:46:53 -0700 (PDT)
Message-Id: <20140825.174653.1190425703684375530.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, x86@kernel.org,
        axboe@kernel.dk, jack@suse.cz, tytso@mit.edu, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] percpu_counter: add @gfp to percpu_counter_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409013812-21700-2-git-send-email-tj@kernel.org>
References: <1409013812-21700-1-git-send-email-tj@kernel.org>
	<1409013812-21700-2-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 17:46:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Mon, 25 Aug 2014 20:43:30 -0400

> Percpu allocator now supports allocation mask.  Add @gfp to
> percpu_counter_init() so that !GFP_KERNEL allocation masks can be used
> with percpu_counters too.
> 
> We could have left percpu_counter_init() alone and added
> percpu_counter_init_gfp(); however, the number of users isn't that
> high and introducing _gfp variants to all percpu data structures would
> be quite ugly, so let's just do the conversion.  This is the one with
> the most users.  Other percpu data structures are a lot easier to
> convert.
> 
> This patch doesn't make any functional difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

For networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
