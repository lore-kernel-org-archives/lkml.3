Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaENSH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:07:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52987 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaENSHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:07:55 -0400
Date: Wed, 14 May 2014 14:07:53 -0400 (EDT)
Message-Id: <20140514.140753.222006976691406699.davem@davemloft.net>
To: zyjzyj2000@gmail.com
Cc: eric.dumazet@gmail.com, Yue.Tao@windriver.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: icmp: account for ICMP out errors because of socket limit
From: David Miller <davem@davemloft.net>
In-Reply-To: <53703DC0.2070204@gmail.com>
References: <53703DC0.2070204@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 May 2014 11:07:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: zhuyj <zyjzyj2000@gmail.com>
Date: Mon, 12 May 2014 11:19:28 +0800

> Hi, Eric && David
> 
>  ____           ______________
> |    |         |              |
> | PC |<------->| MIPS 32 core |
> |____|         |______________|
> 
> When ping from a PC to a board (MIPS 32 core), because of socket
> limit,
> ping echo will fail. But ICMP_MIB_OUTERRORS counter is not
> incremented.
> In this case, "netstat -s" can not report these errors.
> 
> This patch will fix this problem. Now it is in the attachment. Please
> check it.

The only time icmp_xmit_lock() can fail is if we try to generate an ICMP
response to a failure to send another ICMP packet.

It is an entirely different situation from Eric's other patch which
you've mentioned in this thread, and I do not think this case warrants
a statistic bump at all.
