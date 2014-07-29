Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaG2TVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:21:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48029 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaG2TVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:21:08 -0400
Date: Tue, 29 Jul 2014 12:21:06 -0700 (PDT)
Message-Id: <20140729.122106.1193653186424252040.davem@davemloft.net>
To: ryabinin.a.a@gmail.com
Cc: hannes@stressinduktion.org, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sasha.levin@oracle.com,
        a.ryabinin@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH] net: sendmsg: fix NULL pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406395618-4697-1-git-send-email-a.ryabinin@samsung.com>
References: <1406390080.22881.75.camel@localhost>
	<1406395618-4697-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Jul 2014 12:21:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Date: Sat, 26 Jul 2014 21:26:58 +0400

> Sasha's report:
 ...
> This reports means that we've come to netlink_sendmsg() with msg->msg_name == NULL and msg->msg_namelen > 0.
> 
> After this report there was no usual "Unable to handle kernel NULL pointer dereference"
> and this gave me a clue that address 0 is mapped and contains valid socket address structure in it.
> 
> This bug was introduced in f3d3342602f8bcbf37d7c46641cb9bca7618eb1c
> (net: rework recvmsg handler msg_name and msg_namelen logic).
> Commit message states that:
> 	"Set msg->msg_name = NULL if user specified a NULL in msg_name but had a
> 	 non-null msg_namelen in verify_iovec/verify_compat_iovec. This doesn't
> 	 affect sendto as it would bail out earlier while trying to copy-in the
> 	 address."
> But in fact this affects sendto when address 0 is mapped and contains
> socket address structure in it. In such case copy-in address will succeed,
> verify_iovec() function will successfully exit with msg->msg_namelen > 0
> and msg->msg_name == NULL.
> 
> This patch fixes it by setting msg_namelen to 0 if msg_name == NULL.
> 
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: <stable@vger.kernel.org>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

Applied and queued up for -stable, thanks!
