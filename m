Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaCXLKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:10:52 -0400
Received: from mail.us.es ([193.147.175.20]:44322 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbaCXLKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:10:50 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus5 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.1/18677. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-100.2/7.5):. 
 Processed in 3.13671 secs); 24 Mar 2014 11:10:49 -0000
X-Spam-ASN: AS12715 95.20.0.0/16
X-Envelope-From: pneira@us.es
Date: Mon, 24 Mar 2014 12:10:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        eparis@redhat.com, sgrubb@redhat.com, hadi@mojatatu.com,
        davem@davemloft.net
Subject: Re: [PATCH] netlink: simplify nfnetlink_bind
Message-ID: <20140324111044.GC5074@localhost>
References: <d9a410952c6b88e5855d36f91c06d466d2ce9bed.1395418617.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9a410952c6b88e5855d36f91c06d466d2ce9bed.1395418617.git.rgb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 12:44:09PM -0400, Richard Guy Briggs wrote:
> Remove duplicity and simplify code flow by moving the rcu_read_unlock() above
> the condition and let the flow control exit naturally at the end of the
> function.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  net/netfilter/nfnetlink.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 046aa13..75619f9 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -399,12 +399,10 @@ static void nfnetlink_bind(int group)
>  
>  	rcu_read_lock();
>  	ss = nfnetlink_get_subsys(type);
> +	rcu_read_unlock();
>  	if (!ss) {
> -		rcu_read_unlock();
>  		request_module("nfnetlink-subsys-%d", type);
> -		return;
>  	}
> -	rcu_read_unlock();

Applied with minor glitch. Removed the brackets in that if branch.
Thanks
