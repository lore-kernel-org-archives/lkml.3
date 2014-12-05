Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaLEHVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:21:20 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:11612
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbaLEHVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:21:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,521,1413237600"; 
   d="scan'208";a="91895443"
Date: Fri, 5 Dec 2014 08:21:15 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by
 pr_warn() in mppe_rekey()
In-Reply-To: <1417731809.2721.17.camel@perches.com>
Message-ID: <alpine.DEB.2.02.1412050820290.2059@localhost6.localdomain6>
References: <1417731809.2721.17.camel@perches.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Dec 2014, Joe Perches wrote:

> On Thu, 2014-12-04 at 23:10 +0100, SF Markus Elfring wrote:
> > The mppe_rekey() function contained a few update candidates.
> > * Curly brackets were still used around a single function call "printk".
> > * Unwanted space characters
> > 
> > Let us improve these implementation details according to the current Linux
> > coding style convention.
> 
> trivia:
> 
> > diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
> []
> > @@ -172,9 +172,8 @@ static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
> >  		setup_sg(sg_in, state->sha1_digest, state->keylen);
> >  		setup_sg(sg_out, state->session_key, state->keylen);
> >  		if (crypto_blkcipher_encrypt(&desc, sg_out, sg_in,
> > -					     state->keylen) != 0) {
> > -    		    printk(KERN_WARNING "mppe_rekey: cipher_encrypt failed\n");
> > -		}
> > +					     state->keylen) != 0)
> > +			pr_warn("mppe_rekey: cipher_encrypt failed\n");
> 
> It's generally nicer to replace embedded function names
> with "%s: ", __func__
> 
> 			pr_warn("%s: cipher_encrypt failed\n", __func__);

Doing so may potentially allow some strings to be shared, thus saving a 
little space.  Perhaps not in this case, though.

julia
