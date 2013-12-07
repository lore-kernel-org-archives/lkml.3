Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab3LGAK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:10:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39728 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729Ab3LGAK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:10:27 -0500
Date: Sat, 7 Dec 2013 00:10:24 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, "David S. Miller" <davem@davemloft.net>
Message-ID: <20131207001024.GT31504@decadent.org.uk>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
 <1386371476-2477-4-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386371476-2477-4-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 3.8 003/152] cxgb3: Fix length calculation in
 write_ofld_wr() on 32-bit architectures
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 03:08:47PM -0800, Kamal Mostafa wrote:
> 3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ben Hutchings <ben@decadent.org.uk>
> 
> [ Upstream commit 262e827fe745642589450ae241b7afd3912c3f25 ]
> 
> The length calculation here is now invalid on 32-bit architectures,
> since sk_buff::tail is a pointer and sk_buff::transport_header is
> an integer offset:
> 
> drivers/net/ethernet/chelsio/cxgb3/sge.c: In function 'write_ofld_wr':
> drivers/net/ethernet/chelsio/cxgb3/sge.c:1603:9: warning: passing argument 4 of 'make_sgl' makes integer from pointer without a cast [enabled by default]
>          adap->pdev);
>          ^
> drivers/net/ethernet/chelsio/cxgb3/sge.c:964:28: note: expected 'unsigned int' but argument is of type 'sk_buff_data_t'
>  static inline unsigned int make_sgl(const struct sk_buff *skb,
>                             ^
> 
> Use the appropriate skb accessor functions.
> 
> Compile-tested only.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Fixes: 1a37e412a022 ('net: Use 16bits for *_headers fields of struct skbuff')
[...]

This is only needed for 3.11+, though it should be harmless for
older versions.

Ben.

-- 
Ben Hutchings
Design a system any fool can use, and only a fool will want to use it.
