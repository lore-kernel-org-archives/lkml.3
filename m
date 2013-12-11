Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3LKCpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:45:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53823 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3LKCps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:45:48 -0500
Date: Tue, 10 Dec 2013 21:45:46 -0500 (EST)
Message-Id: <20131210.214546.2076606671956419677.davem@davemloft.net>
To: xemul@parallels.com
Cc: sasha.levin@oracle.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: unix: allow set_peek_off to fail
From: David Miller <davem@davemloft.net>
In-Reply-To: <52A5721E.6020709@parallels.com>
References: <1386455187-28597-1-git-send-email-sasha.levin@oracle.com>
	<52A5721E.6020709@parallels.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 10 Dec 2013 18:45:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@parallels.com>
Date: Mon, 9 Dec 2013 11:32:46 +0400

> On 12/08/2013 02:26 AM, Sasha Levin wrote:
>> unix_dgram_recvmsg() will hold the readlock of the socket until recv
>> is complete.
>> 
>> In the same time, we may try to setsockopt(SO_PEEK_OFF) which will hang until
>> unix_dgram_recvmsg() will complete (which can take a while) without allowing
>> us to break out of it, triggering a hung task spew.
>> 
>> Instead, allow set_peek_off to fail, this way userspace will not hang.
>> 
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> 
> Acked-by: Pavel Emelyanov <xemul@parallels.com>

Applied and queued up for -stable, thanks.
