Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3JKVzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:55:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56367 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3JKVzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 17:55:38 -0400
Date: Fri, 11 Oct 2013 17:55:36 -0400 (EDT)
Message-Id: <20131011.175536.1301172695781705007.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: ou.ghorbel@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: Initialize ip6_tnl.hlen in gre tunnel even if no
 route is found
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131011150216.GA18601@order.stressinduktion.org>
References: <1381427427-14880-1-git-send-email-ou.ghorbel@gmail.com>
	<20131011150216.GA18601@order.stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 11 Oct 2013 14:55:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Fri, 11 Oct 2013 17:02:17 +0200

> On Thu, Oct 10, 2013 at 06:50:27PM +0100, Oussama Ghorbel wrote:
>> The ip6_tnl.hlen (gre and ipv6 headers length) is independent from the
>> outgoing interface, so it would be better to initialize it even when no
>> route is found, otherwise its value will be zero.
>> While I'm not sure if this could happen in real life, but doing that
>> will avoid to call the skb_push function with a zero in ip6gre_header
>> function.
>> 
>> Suggested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
>> Signed-off-by: Oussama Ghorbel <ou.ghorbel@gmail.com>
> 
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Applied.
