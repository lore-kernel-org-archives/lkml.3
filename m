Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaBQSu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:50:56 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:33192 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaBQSuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:50:55 -0500
Date: Mon, 17 Feb 2014 19:50:53 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION v3.14-rc2] NULL dereference in icmp6_send()
Message-ID: <20140217185053.GF22833@order.stressinduktion.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <nsxzjlp4lxm.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <nsxzjlp4lxm.fsf@closure.thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, Feb 17, 2014 at 01:46:13PM -0500, Theodore Ts'o wrote:
> I was sitting in the Admiral's Club of Boston Logan airport, having
> connected to the free airport wifi, although I had not yet logged into
> the captive portal, when I received the following BUG.   I've also seen
> this once before when connected to my home network (running the CeroWRT
> stable snapshot, versoin 3.7.5-2), although I wasn't able to get a
> screen shot that time:
> 
> https://plus.google.com/photos/+TheodoreTso/albums/5981437894092747105/5981437896646076466
> 
> The transcribed stack dump is:
> 
> icmp6_send
> ip6_expire_frag_queue
> ip6_frag_expire
> call_timer_fn
> run_timer_softirq
> irq_exit
> ...
> 
> I was running v3.13 and v3.13-rcX previously without seeing this, so I
> suspect this is a regression.

At that point the skb does not have a dst attached, so we panic in
icmp6_send.

This is fixed here:
https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=d94c1f92bbf2c42c5febd68bbea51fffeac90834

Greetings,

  Hannes

