Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaIBEXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 00:23:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47207 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaIBEXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 00:23:32 -0400
Date: Mon, 01 Sep 2014 21:23:28 -0700 (PDT)
Message-Id: <20140901.212328.1826121359590626658.davem@davemloft.net>
To: bpoirier@suse.de
Cc: prashant@broadcom.com, mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v5 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409345191-8819-4-git-send-email-bpoirier@suse.de>
References: <1409345191-8819-1-git-send-email-bpoirier@suse.de>
	<1409345191-8819-4-git-send-email-bpoirier@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Sep 2014 21:23:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>
Date: Fri, 29 Aug 2014 13:46:31 -0700

> This puts us in the exceptional situation that a single skb that
> triggers tg3_tso_bug() may require the entire tx ring.

This is really silly.

If you get fed crap, linearize the SKB, end of story.

Don't try to be clever, and absolutely do not adjust gso_max_segs on
the fly as it was never ever designed to change dynamically and
asynchronously to the code paths which use it to size outgoing TCP
segments.

Nothing else needs adjusting, just linearize when you run into a
packet that can't fit into the TX ring because of these weird
restrictions.
