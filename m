Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab3ESTzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 15:55:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58439 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3ESTzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 15:55:33 -0400
Date: Sun, 19 May 2013 21:58:10 +0200
From: Alexander Aring <alex.aring@gmail.com>
To: David Hauweele <david@hauweele.net>
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] 6lowpan: Fix fragmentation with link-local
 compressed addresses
Message-ID: <20130519195809.GA3237@x61s.Speedport_W_921V_1_21_000>
References: <1368987211-19826-1-git-send-email-david@hauweele.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1368987211-19826-1-git-send-email-david@hauweele.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

can you use a link-layer address on the current net-next kernel?

I am asking because I can't use a link-layer address currently.
Your patch doesn't help to solve my problem with link-layer addresses.


To your patch:

We get the link-layer addresses from skb not from the allocated
frame->skb.

Here is the code:

_saddr = mac_cb(skb)->sa.hwaddr;
_daddr = mac_cb(skb)->da.hwaddr;

Here is skb != frame->skb so we don't need to copy it to frame->skb->cb
because we already the link-layer addresses from skb->cb.

Is there another place in the code where we get the link-layer addresses
from allocated "frame" structure?

Regards
Alex
