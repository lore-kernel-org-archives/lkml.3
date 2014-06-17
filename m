Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270AbaFQVdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:33:07 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:47032 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964856AbaFQVdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:33:04 -0400
X-IronPort-AV: E=Sophos;i="5.01,496,1400018400"; 
   d="scan'208";a="80624597"
Date: Tue, 17 Jun 2014 23:33:00 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        Gilles Muller <Gilles.Muller@lip6.fr>
Subject: Re: [PATCH 1/1] scripts/coccinelle/free: add conditional kfree
 test
In-Reply-To: <1403035539.2722.3.camel@joe-AO725>
Message-ID: <alpine.DEB.2.02.1406172331001.2055@localhost6.localdomain6>
References: <1403034199-9824-1-git-send-email-fabf@skynet.be> <1403035539.2722.3.camel@joe-AO725>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2014, Joe Perches wrote:

> On Tue, 2014-06-17 at 21:43 +0200, Fabian Frederick wrote:
> > This patch adds a trivial script warning on
> > 
> > if(foo)
> > 	kfree(foo)
> > 
> > (based on checkpatch)
> []
> > diff --git a/scripts/coccinelle/free/cond_kfree.cocci b/scripts/coccinelle/free/cond_kfree.cocci
> []
> > +* if (E)
> > +*	kfree@p(E);
> 
> You should probably add all of the unnecessary
> conditional tests that checkpatch uses:
> 
> kfree
> usb_free_urb
> debugfs_remove
> debugfs_remove_recursive

Personally, I would prefer that the message encourage the user to consider 
whether it is necessary to call these functions with NULL as an argument 
in any case.

julia
