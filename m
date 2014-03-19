Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbaCSDOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 23:14:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58181 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241AbaCSDN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 23:13:58 -0400
Date: Tue, 18 Mar 2014 23:13:56 -0400 (EDT)
Message-Id: <20140318.231356.794206182931803937.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140318182752.ed10b8c685f31839f84a1ece@canb.auug.org.au>
References: <20140318182752.ed10b8c685f31839f84a1ece@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Mar 2014 20:13:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 18 Mar 2014 18:27:52 +1100

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> net/netfilter/nft_hash.c: In function 'nft_hash_tbl_free':
> net/netfilter/nft_hash.c:79:3: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]

I've applied the patch below to fix this, thanks.

> Caused by commit ce6eb0d7c8ec ("netfilter: nft_hash: bug fixes and
> resizing") from the net-next tree.  See Rule 1 in
> Documentation/SubmitChecklist.

This slips through a lot, and would happen less often if core x86
headers didn't bring in vmalloc.h :-)
