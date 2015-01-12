Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbbALCye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 21:54:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43198 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbbALCy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 21:54:29 -0500
Date: Sun, 11 Jan 2015 21:54:27 -0500 (EST)
Message-Id: <20150111.215427.2061918421162909520.davem@davemloft.net>
To: cj@linux.com
Cc: willemb@google.com, edumazet@google.com, dborkman@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] packet: bail out of packet_snd() if L2 header
 creation fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420999276-28225-1-git-send-email-cj@linux.com>
References: <1420999276-28225-1-git-send-email-cj@linux.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Jan 2015 18:54:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Jaeger <cj@linux.com>
Date: Sun, 11 Jan 2015 13:01:16 -0500

> Due to a misplaced parenthesis, the expression
> 
>   (unlikely(offset) < 0),
> 
> which expands to
> 
>   (__builtin_expect(!!(offset), 0) < 0),
> 
> never evaluates to true. Therefore, when sending packets with
> PF_PACKET/SOCK_DGRAM, packet_snd() does not abort as intended
> if the creation of the layer 2 header fails.
> 
> Spotted by Coverity - CID 1259975 ("Operands don't affect result").
> 
> Fixes: 9c7077622dd9 ("packet: make packet_snd fail on len smaller than l2 header")
> Signed-off-by: Christoph Jaeger <cj@linux.com>

Applied, thank you.
