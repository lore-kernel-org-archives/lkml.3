Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaBYBcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:32:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49111 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaBYBcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:32:42 -0500
Date: Mon, 24 Feb 2014 20:32:40 -0500 (EST)
Message-Id: <20140224.203240.898686891281813790.davem@davemloft.net>
To: kyle@infradead.org
Cc: bp@alien8.de, nic_swsd@realtek.com, romieu@fr.zoreil.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: initialize rtl8169_stats seqlock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140225011228.GC14970@merlin.infradead.org>
References: <20140224231748.GA18598@pd.tnic>
	<20140225011228.GC14970@merlin.infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2014 17:32:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@infradead.org>
Date: Mon, 24 Feb 2014 20:12:28 -0500

> From: Kyle McMartin <kyle@redhat.com>
> 
> Boris reports he's seeing:
>> [    9.195943] INFO: trying to register non-static key.
>> [    9.196031] the code is fine but needs lockdep annotation.
>> [    9.196031] turning off the locking correctness validator.
>> [    9.196031] CPU: 1 PID: 933 Comm: modprobe Not tainted 3.14.0-rc4+ #1
> with the r8169 driver.
> 
> These are occuring because the seqcount embedded in u64_stats_sync on
> 32-bit SMP is uninitialized which is making lockdep unhappy.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Good catch, applied, thanks Kyle.
