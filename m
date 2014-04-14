Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaDNWv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:51:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59877 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaDNWv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:51:56 -0400
Date: Mon, 14 Apr 2014 18:51:52 -0400 (EDT)
Message-Id: <20140414.185152.204599887297456936.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: nasa4836@gmail.com, jchapman@katalix.com, edumazet@google.com,
        joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] A panic caused by null pointer dereference aftering
 updating to
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397510604.4222.63.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1397502396.4222.45.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140414.152225.1983723140136958968.davem@davemloft.net>
	<1397510604.4222.63.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Apr 2014 15:51:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Apr 2014 14:23:24 -0700

> I was trying to cook a not too invasive patch.
> 
> Changing ip_local_out() means changing dst_output() / nf_hook()  and
> hundred of call sites.
> 
> Unless I misunderstood you ?

You could make ip_local_out(skb) be __ip_local_out(skb, skb->sk) and
make tunnel output use __ip_local_out().
