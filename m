Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaDNSss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:48:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57307 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbaDNSsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:48:46 -0400
Date: Mon, 14 Apr 2014 14:48:43 -0400 (EDT)
Message-Id: <20140414.144843.488522666550066271.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: nasa4836@gmail.com, jchapman@katalix.com, edumazet@google.com,
        joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] A panic caused by null pointer dereference aftering
 updating to
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397499566.4222.36.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1397498082.4222.29.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140414.140253.788885546068554928.davem@davemloft.net>
	<1397499566.4222.36.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Apr 2014 11:48:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Apr 2014 11:19:26 -0700

> ip_local_out() doesn't use skb->sk

It does Eric.

We had just such a report with this in the backtrace, when AF_PACKET
sends over vxlan devices.

The problem is ip_mc_output().
