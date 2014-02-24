Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaBXWXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:23:24 -0500
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:58329 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752376AbaBXWXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:23:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:2894:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:4321:5007:6119:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fish60_5736604d43412
X-Filterd-Recvd-Size: 2055
Message-ID: <1393280598.11020.77.camel@joe-AO722>
Subject: Re: [PATCH 6/8] security: smack: Use a more current logging style
From: Joe Perches <joe@perches.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Date: Mon, 24 Feb 2014 14:23:18 -0800
In-Reply-To: <530BC4BF.2000904@schaufler-ca.com>
References: <cover.1393279025.git.joe@perches.com>
	 <3b69f0961dff21133e276d5c3edee8b05c41f8c5.1393279025.git.joe@perches.com>
	 <530BC4BF.2000904@schaufler-ca.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 14:16 -0800, Casey Schaufler wrote:
> On 2/24/2014 1:59 PM, Joe Perches wrote:
> > Convert printks to pr_<level>
> > Add pr_fmt.

> > diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
[]
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> 
> What is pr_fmt() for?

Prefixing "smack: " to the pr_<level> uses.

> > @@ -2106,8 +2108,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
> >  		if (sock->sk->sk_family == PF_INET) {
> >  			rc = smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
> >  			if (rc != 0)
> > -				printk(KERN_WARNING
> > -					"Smack: \"%s\" netlbl error %d.\n",
> > +				pr_warn("\"%s\" netlbl error %d\n",
> >  					__func__, -rc);

This will be now be emitted as

<4>smack: "smack_inode_setsecurity" netlbl error -<d>

instead of

<4>Smack: "smack_inode_setsecurity" netlbl error -<d>

Though it'd be a lot more common to use:

					pr_warn("%s: netlbl error: %d\n",
						__func__, -rc);

so the output would be:

<4>smack: smack_inode_setsecurity: netlbl error: -<d>


