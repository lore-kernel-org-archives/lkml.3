Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab3CQQK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 12:10:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45852 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3CQQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 12:10:27 -0400
Date: Sun, 17 Mar 2013 12:10:26 -0400 (EDT)
Message-Id: <20130317.121026.733329595817911776.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        edumazet@google.com
Subject: Re: [PATCH net-next 1/2] net_sched: don't do precise pkt_len
 computation for untrusted packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363333305-54398-1-git-send-email-jasowang@redhat.com>
References: <1363333305-54398-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 17 Mar 2013 09:10:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 15 Mar 2013 15:41:44 +0800

> Commit 1def9238d4aa2 (net_sched: more precise pkt_len computation) tries to do
> precise packet len computation for GSO packets, but it does not check whether
> the packets were from untrusted source. This is wrong since: we haven't done
> header check before so both gso_segs and headers may not be correct. So this
> patch just bypass the precise pkt_len computation for packet from untrusted
> source (SKB_GSO_DODGY).
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I do not think this is appropriate or even necessary.

All the user can do by reporting an incorrect header size or GSO segs
is hurt himself, by making his traffic take more packet scheduler
quota.

When we do precise accounting, it increases, never decreases, the
amount that a packet "costs" as far as the packet scheduler is
concerned.
