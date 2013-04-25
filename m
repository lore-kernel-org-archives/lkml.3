Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab3DYStB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 14:49:01 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:65332 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449Ab3DYSs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 14:48:59 -0400
Message-ID: <1366915736.8964.171.camel@edumazet-glaptop>
Subject: Re: [PATCH net 1/3] unix/dgram: peek beyond 0-sized skbs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Apr 2013 11:48:56 -0700
In-Reply-To: <1366897638-21882-1-git-send-email-bpoirier@suse.de>
References: <1366897638-21882-1-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 09:47 -0400, Benjamin Poirier wrote:
> "77c1090 net: fix infinite loop in __skb_recv_datagram()" (v3.8) introduced a
> regression:
> After that commit, recv can no longer peek beyond a 0-sized skb in the queue.
> __skb_recv_datagram() instead stops at the first skb with len == 0 and results
> in the system call failing with -EFAULT via skb_copy_datagram_iovec().


if MSG_PEEK is not used, what happens here ?

It doesn't look right to me that we return -EFAULT if skb->len is 0,
EFAULT is reserved to faulting (ie reading/writing at least one byte)

How are we telling the user message had 0 byte, but its not EOF ?



