Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3JUWpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:45:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44284 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3JUWpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:45:11 -0400
Date: Mon, 21 Oct 2013 18:45:09 -0400 (EDT)
Message-Id: <20131021.184509.1933008514161772000.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        amwang@redhat.com
Subject: Re: [PATCH] Revert "bridge: only expire the mdb entry when query
 is received"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382223537-10844-1-git-send-email-linus.luessing@web.de>
References: <1382223537-10844-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 15:45:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Sun, 20 Oct 2013 00:58:57 +0200

> While this commit was a good attempt to fix issues occuring when no
> multicast querier is present, this commit still has two more issues:
> 
> 1) There are cases where mdb entries do not expire even if there is a
> querier present. The bridge will unnecessarily continue flooding
> multicast packets on the according ports.
> 
> 2) Never removing an mdb entry could be exploited for a Denial of
> Service by an attacker on the local link, slowly, but steadily eating up
> all memory.
> 
> Actually, this commit became obsolete with
> "bridge: disable snooping if there is no querier" (b00589af3b)
> which included fixes for a few more cases.
> 
> Therefore reverting the following commits (the commit stated in the
> commit message plus three of its follow up fixes):
> 
> ---
> Revert "bridge: update mdb expiration timer upon reports."
> This reverts commit f144febd93d5ee534fdf23505ab091b2b9088edc.
> Revert "bridge: do not call setup_timer() multiple times"
> This reverts commit 1faabf2aab1fdaa1ace4e8c829d1b9cf7bfec2f1.
> Revert "bridge: fix some kernel warning in multicast timer"
> This reverts commit c7e8e8a8f7a70b343ca1e0f90a31e35ab2d16de1.
> Revert "bridge: only expire the mdb entry when query is received"
> This reverts commit 9f00b2e7cf241fa389733d41b615efdaa2cb0f5b.
> ---

Cong, and other bridge folks, please review this revert.

Thanks.
