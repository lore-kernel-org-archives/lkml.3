Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaKBPpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 10:45:12 -0500
Received: from mail.passe0815.de ([188.40.49.9]:59874 "EHLO mail.passe0815.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbaKBPpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 10:45:07 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Nov 2014 10:45:06 EST
Date: Sun, 2 Nov 2014 16:37:33 +0100
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge: fix netfilter/NF_BR_LOCAL_OUT for own, locally
 generated queries
Message-ID: <20141102153733.GA23084@odroid>
References: <1411342364-4791-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411342364-4791-1-git-send-email-linus.luessing@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-GPG-Mailgate: Not encrypted, public key not found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 01:32:44AM +0200, Linus Lüssing wrote:
> Ebtables on the OUTPUT chain (NF_BR_LOCAL_OUT) would not work as expected
> for both locally generated IGMP and MLD queries. The IP header specific
> filter options are off by 14 Bytes for netfilter (actual output on
> interfaces is fine).
> 
> NF_HOOK() expects the skb->data to point to the IP header, not the
> ethernet one (while dev_queue_xmit() does not). Luckily there is an
> br_dev_queue_push_xmit() helper function already - let's just use that.

bump
