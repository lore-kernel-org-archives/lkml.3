Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaLEG0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:26:30 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:17066
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbaLEG00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:26:26 -0500
X-IronPort-AV: E=Sophos;i="5.07,521,1413237600"; 
   d="scan'208";a="91873678"
Date: Fri, 5 Dec 2014 07:26:22 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by
 pr_warn() in mppe_rekey()
In-Reply-To: <1417733101.2721.20.camel@perches.com>
Message-ID: <alpine.DEB.2.02.1412050726000.2059@localhost6.localdomain6>
References: <5307CAA2.8060406@users.sourceforge.net>  <530A72AA.3000601@users.sourceforge.net>  <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>  <530B5FB6.6010207@users.sourceforge.net>  <alpine.DEB.2.10.1402241710370.2074@hadrien> 
 <530C5E18.1020800@users.sourceforge.net>  <alpine.DEB.2.10.1402251014170.2080@hadrien>  <530CD2C4.4050903@users.sourceforge.net>  <alpine.DEB.2.10.1402251840450.7035@hadrien>  <530CF8FF.8080600@users.sourceforge.net>  <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
  <530DD06F.4090703@users.sourceforge.net>  <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>  <5317A59D.4@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com>  <547C82A6.2030808@users.sourceforge.net>  <547CA157.1080401@cogentembedded.com>
  <5480DA32.8000201@users.sourceforge.net>  <5480DBDE.7040604@users.sourceforge.net>  <1417731809.2721.17.camel@perches.com>  <5480DFB5.4090708@users.sourceforge.net> <1417733101.2721.20.camel@perches.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014, Joe Perches wrote:

> On Thu, 2014-12-04 at 23:27 +0100, SF Markus Elfring wrote:
> > >> diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
> > > []
> > >> @@ -172,9 +172,8 @@ static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
> > >>  		setup_sg(sg_in, state->sha1_digest, state->keylen);
> > >>  		setup_sg(sg_out, state->session_key, state->keylen);
> > >>  		if (crypto_blkcipher_encrypt(&desc, sg_out, sg_in,
> > >> -					     state->keylen) != 0) {
> > >> -    		    printk(KERN_WARNING "mppe_rekey: cipher_encrypt failed\n");
> > >> -		}
> > >> +					     state->keylen) != 0)
> > >> +			pr_warn("mppe_rekey: cipher_encrypt failed\n");
> > > 
> > > It's generally nicer to replace embedded function names
> > > with "%s: ", __func__
> > > 
> > > 			pr_warn("%s: cipher_encrypt failed\n", __func__);
> > 
> > Do you want that I send a third patch series for the fine-tuning of these parameters?
> 
> If you want.
> 
> I just wanted you to be aware of it for future patches.

Markus, are you sure that you cannot use netdev_warn in this case?

julia
