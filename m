Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaHBW00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:26:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49594 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbaHBW0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:26:24 -0400
Date: Sat, 02 Aug 2014 15:26:23 -0700 (PDT)
Message-Id: <20140802.152623.2217732437810296124.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iovec: make sure the caller actually wants anything in
 memcpy_fromiovecend
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406862035-27818-1-git-send-email-sasha.levin@oracle.com>
References: <1406862035-27818-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 Aug 2014 15:26:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Thu, 31 Jul 2014 23:00:35 -0400

> Check for cases when the caller requests 0 bytes instead of running off
> and dereferencing potentially invalid iovecs.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Applied, thanks.

BTW, if you look at the function above this one (memcpy_toiovecend) it avoids
this issue by encompassing all of the logic in a top-level loop which terminates
when len <= 0.
