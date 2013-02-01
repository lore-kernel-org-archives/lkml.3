Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3BAPaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:30:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:49892 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab3BAPaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:30:17 -0500
Date: Fri, 1 Feb 2013 16:32:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Feng Gao <gfree.wind@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ 82/89] netfilter: xt_hashlimit: fix race that results in
 duplicated entries
Message-ID: <20130201153217.GA27799@kroah.com>
References: <20130201130207.444989281@linuxfoundation.org>
 <20130201130213.388508268@linuxfoundation.org>
 <CA+6hz4qjj3wGgo-m50=qRxAN+OGUXKfUfgRp7Pys7NixgwQ3vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+6hz4qjj3wGgo-m50=qRxAN+OGUXKfUfgRp7Pys7NixgwQ3vQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 11:04:36PM +0800, Feng Gao wrote:
> Hi Greg,
> 
> I have a question.
> 
> There are two duplicated lines now.
>                        dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
>                        rateinfo_recalc(dh, now, hinfo->cfg.mode);
> 1# case: The dsthash_find return a valid dh;
> 2# case: There is a race. The race is true.
> 
> Why we could not adopt the method I sent before. 
> 
>     dh = dsthash_find(hinfo, &dst);
>     if (dh == NULL) {
>         dh = dsthash_alloc_init(hinfo, &dst, &new_node);
>         if (dh == NULL) {
>             rcu_read_unlock_bh();
>             goto hotdrop;
>         }
>     }
> 
>     if (new_node) {
>         dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
>         rateinfo_init(dh, hinfo);
>     } else {
>         /* update expiration timeout */
>         dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
>         rateinfo_recalc(dh, now, hinfo->cfg.mode);
>     }
> 
> I think it could avoid the two duplicated lines.

But this patch the same as what is in Linus's tree, right?  If not,
please let me know.  If it is the same, and you want to change it, it
needs to be changed in Linus's tree first before I can do anything in
the stable kernels.

thanks,

greg k-h
