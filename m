Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3GYI4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:56:19 -0400
Received: from etezian.org ([198.101.225.253]:41835 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab3GYI4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:56:14 -0400
Date: Thu, 25 Jul 2013 10:57:38 +0200
From: Andi Shyti <andi@etezian.org>
To: davem@davemloft.net
Cc: andi@etezian.org, dominique.martinet@cea.fr, pebolle@tiscali.nl,
        lucho@ionkov.net, ericvh@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        rminnich@sandia.gov
Subject: Re: [PATCH] 9p: client: remove unused code and any reference to
 "cancelled" function
Message-ID: <20130725085738.GC4295@jack.whiskey>
References: <20130725061411.GA8579@nautica>
 <1374742464-10686-1-git-send-email-andi@etezian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374742464-10686-1-git-send-email-andi@etezian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Jul 25, 2013 at 10:54:24AM +0200, Andi Shyti wrote:
> This patch reverts commit
> 
> 80b45261a0b263536b043c5ccfc4ba4fc27c2acc
> 
> which was implementing a 'cancelled' functionality to notify that
> a cancelled request will not be replied.
> 
> This implementation was not used anywhere and therefore removed.

did you mean this?

> -	spin_lock(&c->lock);
>  	if (oldreq->status == REQ_STATUS_FLSH) {
> +		spin_lock(&c->lock);
>  		list_del(&oldreq->req_list);
>  		spin_unlock(&c->lock);
> -		if (c->trans_mod->cancelled)
> -			c->trans_mod->cancelled(c, req);

I just put the spin_lock inside the if statement, so that it
locks only if the statement it's true.

Andi
