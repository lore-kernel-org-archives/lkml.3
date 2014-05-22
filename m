Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaEVUaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:30:08 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42298 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaEVUaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:30:06 -0400
Message-ID: <1400790603.5367.167.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: skbuff truesize incorrect.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jim Baxter <jim_baxter@mentor.com>
Cc: David Miller <davem@davemloft.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kamal@canonical.com, bhutchings@solarflare.com, edumazet@google.com,
        mszeredi@suse.cz, fw@strlen.de
Date: Thu, 22 May 2014 13:30:03 -0700
In-Reply-To: <537E5C63.7080607@mentor.com>
References: <537E4AFD.20304@mentor.com>
	 <20140522.152146.2116142050088142989.davem@davemloft.net>
	 <537E5C63.7080607@mentor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-22 at 21:21 +0100, Jim Baxter wrote:


> OK, so it is the value of the memory that has been allocated for the SKB.
> If there are multiple clones for an skb all pointing at the same data,
> will that distort the memory used when they all have the same truesize?

Its always better to over estimate memory uses, than under estimating.

Its all about guarding against OOM.

Keep in mind some parts of networking stack do not like clones.

TCP coalescing works beautifully with non cloned skbs.

Instead of cloning skb or doing copies, you could play with having frame
on a page fragment. Only headers might need to be pulled from the frame
to linear part of skb.





