Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaBYUUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:20:39 -0500
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:44712 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752810AbaBYUUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:20:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2551:2553:2559:2562:2693:2828:2894:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3872:3873:3874:4321:4385:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12050:12296:12517:12519:12740:13069:13161:13229:13311:13357:13548:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pump69_5c7911b0dd81d
X-Filterd-Recvd-Size: 2688
Message-ID: <1393359634.8716.40.camel@joe-AO722>
Subject: Re: [PATCH 5/8] security: selinux: Use a more current logging style
From: Joe Perches <joe@perches.com>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Date: Tue, 25 Feb 2014 12:20:34 -0800
In-Reply-To: <2895078.vC4M4VjvUd@sifl>
References: <cover.1393279025.git.joe@perches.com>
	 <637b2f31e31f2b0d7a67131f1db125cc0b2bb829.1393279025.git.joe@perches.com>
	 <2895078.vC4M4VjvUd@sifl>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 15:05 -0500, Paul Moore wrote:
> On Monday, February 24, 2014 01:59:58 PM Joe Perches wrote:
> > Convert printk to pr_<level>.
> > Add pr_fmt.
> > Coalesce formats, add missing space where appropriate.
> > Standardize on one space after "SELinux: " prefix.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> A few minor comments inline ...
> 
> > diff --git a/security/selinux/avc.c b/security/selinux/avc.c
[]
> > @@ -13,6 +13,9 @@
> >   *	it under the terms of the GNU General Public License version 2,
> >   *	as published by the Free Software Foundation.
> >   */
> > +
> > +#define pr_fmt(fmt) "SELinux: " KBUILD_MODNAME ": " fmt
> > +
> 
> Wouldn't this result in "SELinux: selinux: ..."?  If not great, if so, let's 
> just specify "avc" the old fashioned way.

Yup, you're right.  Thanks.  I stuffed that one up.

$ strings security/selinux/avc.o | grep "^[0-6]"
4SELinux: selinux: seqno %d < latest_notif %d

I'll send a v2.

> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
[]
> > @@ -5976,9 +5958,9 @@ static __init int selinux_init(void)
> >  		panic("SELinux: Unable to register with kernel.\n");
> > 
> >  	if (selinux_enforcing)
> > -		printk(KERN_DEBUG "SELinux:  Starting in enforcing mode\n");
> > +		printk(KERN_DEBUG "SELinux: Starting in enforcing mode\n");
> >  	else
> > -		printk(KERN_DEBUG "SELinux:  Starting in permissive mode\n");
> > +		printk(KERN_DEBUG "SELinux: Starting in permissive mode\n");

These printks should/will be converted to pr_debug in a
separate patch.  I didn't want to mix these conversions
with the other pr_<level> ones.

