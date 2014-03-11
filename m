Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbaCKU1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:27:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58293 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbaCKU1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:27:16 -0400
Date: Tue, 11 Mar 2014 16:27:14 -0400 (EDT)
Message-Id: <20140311.162714.1118698288267206477.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, jbenc@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] skbuff: fix skb_segment with zero copy skbs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394468807-25980-1-git-send-email-mst@redhat.com>
References: <1394468807-25980-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Mar 2014 13:27:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 10 Mar 2014 18:29:01 +0200

> This fixes a bug in skb_segment where it moves frags
> between skbs without orphaning them.
> This causes userspace to assume it's safe to
> reuse the buffer, and receiver gets corrupted data.
> This further might leak information from the
> transmitter on the wire.
> 
> To fix track which skb does a copied frag belong
> to, and orphan frags when copying them.
> 
> As we are tracking multiple skbs here, using
> short names (skb,nskb,fskb,skb_frag,frag) becomes confusing.
> So before adding another one, I refactor these names
> slightly.
> 
> Patch is split out to make it easier to
> verify that all trasformations are trivially correct.
> 
> The problem was observed in the field,
> so I think that the patch is necessary on stable
> as well.

Series applied and queued up for -stable, thanks for fixing this.
