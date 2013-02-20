Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934996Ab3BTTa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:30:27 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:47096 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934380Ab3BTTaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:30:21 -0500
Message-ID: <1361388619.19353.221.camel@edumazet-glaptop>
Subject: Re: Kernel 3.7.2 strange warning and short system hang
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: bind@enas.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 20 Feb 2013 11:30:19 -0800
In-Reply-To: <20130220.125715.2150428275032134361.davem@davemloft.net>
References: <5124F57A.6080908@enas.net>
	 <1361379176.19353.187.camel@edumazet-glaptop>
	 <20130220.125715.2150428275032134361.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 12:57 -0500, David Miller wrote:

> I've seen this pattern on several occasions and I have to wonder...
> 
> Do we really require, therefore, every NAPI driver to use dev_kfree_skb_any()
> in it's TX reclaim if it supports netpoll?
> 
> That seems completely bogus.
> 


> netpoll is supposed to provide an execution environment when it invokes
> ->poll() that is identical to the normal NAPI execution.  If that would
> be true, then this change above would be completely unnecessary.
> 
> We need to figure out what is the case here, and audit all the NAPI
> drivers to make sure they do the right thing once we know what the
> right thing actually is.

netpoll directly calls n->poll()

(poll_napi() -> poll_one_napi() -> napi->poll(napi, budget) )

Presumably it should not do that if running in interrupt context.



