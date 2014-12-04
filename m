Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaLDWXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:23:34 -0500
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:32994 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751663AbaLDWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:23:33 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3867:3872:4321:5007:6261:7901:8660:10004:10400:10848:11026:11232:11658:11914:12043:12219:12438:12485:12517:12519:12740:13069:13148:13230:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brush49_75e8a5c0e9350
X-Filterd-Recvd-Size: 3144
Message-ID: <1417731809.2721.17.camel@perches.com>
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by
 pr_warn() in mppe_rekey()
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Thu, 04 Dec 2014 14:23:29 -0800
In-Reply-To: <5480DBDE.7040604@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <530A086E.8010901@users.sourceforge.net>
	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	 <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net>
	 <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com>
	 <547C82A6.2030808@users.sourceforge.net>
	 <547CA157.1080401@cogentembedded.com>
	 <5480DA32.8000201@users.sourceforge.net>
	 <5480DBDE.7040604@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 23:10 +0100, SF Markus Elfring wrote:
> The mppe_rekey() function contained a few update candidates.
> * Curly brackets were still used around a single function call "printk".
> * Unwanted space characters
> 
> Let us improve these implementation details according to the current Linux
> coding style convention.

trivia:

> diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
[]
> @@ -172,9 +172,8 @@ static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
>  		setup_sg(sg_in, state->sha1_digest, state->keylen);
>  		setup_sg(sg_out, state->session_key, state->keylen);
>  		if (crypto_blkcipher_encrypt(&desc, sg_out, sg_in,
> -					     state->keylen) != 0) {
> -    		    printk(KERN_WARNING "mppe_rekey: cipher_encrypt failed\n");
> -		}
> +					     state->keylen) != 0)
> +			pr_warn("mppe_rekey: cipher_encrypt failed\n");

It's generally nicer to replace embedded function names
with "%s: ", __func__

			pr_warn("%s: cipher_encrypt failed\n", __func__);


