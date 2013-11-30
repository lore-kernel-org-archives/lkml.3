Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3K3RtK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 12:49:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33401 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3K3RtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 12:49:07 -0500
Date: Sat, 30 Nov 2013 12:49:05 -0500 (EST)
Message-Id: <20131130.124905.1525994055463627833.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: hannes@stressinduktion.org, jongman.heo@samsung.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: fix possible seqlock deadlock in
 ip6_finish_output2
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385829955.5352.40.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20131128192231.GE24171@order.stressinduktion.org>
	<20131129053944.GH24171@order.stressinduktion.org>
	<1385829955.5352.40.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 30 Nov 2013 09:49:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 30 Nov 2013 08:45:55 -0800

> On Fri, 2013-11-29 at 06:39 +0100, Hannes Frederic Sowa wrote:
>> IPv6 stats are 64 bits and thus are protected with a seqlock. By not
>> disabling bottom-half we could deadlock here if we don't disable bh and
>> a softirq reentrantly updates the same mib.
>> 
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
>> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
>> ---
> 
> Acked-by: Eric Dumazet <edumazet@google.com>
> 
> (Note that the seqlock is only for 32bit arches)

Applied and queued up for -stable, thanks.
