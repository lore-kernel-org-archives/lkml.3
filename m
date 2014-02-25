Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaBYTeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:34:20 -0500
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:47190 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753307AbaBYTeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:34:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2894:3138:3139:3140:3141:3142:3352:3622:3867:3868:3871:3874:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: place23_7c61396d4a041
X-Filterd-Recvd-Size: 1998
Message-ID: <1393356852.8716.33.camel@joe-AO722>
Subject: Re: [PATCH 1/8] security: Use a more current logging style
From: Joe Perches <joe@perches.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Date: Tue, 25 Feb 2014 11:34:12 -0800
In-Reply-To: <20140225191003.GB22246@sergelap>
References: <cover.1393279025.git.joe@perches.com>
	 <c90a7238c10c2b243b10bc19632d3428e5bbb1fb.1393279025.git.joe@perches.com>
	 <20140225191003.GB22246@sergelap>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 13:10 -0600, Serge Hallyn wrote:
> Quoting Joe Perches (joe@perches.com):
> > Convert printks to pr_<level>.
[]
> Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
> 
> Though should warn_setuid_and_fcaps_mixed be using
> pr_info_once()?

Yup, thanks.  I'll send a follow-on with your reported-by
if/after this is applied and I'll send a V2 now so James
could apply that instead if that's what he prefers.

> > diff --git a/security/commoncap.c b/security/commoncap.c
[]
> > @@ -46,9 +48,8 @@ static void warn_setuid_and_fcaps_mixed(const char *fname)
> >  {
> >  	static int warned;
> >  	if (!warned) {
> > -		printk(KERN_INFO "warning: `%s' has both setuid-root and"
> > -			" effective capabilities. Therefore not raising all"
> > -			" capabilities.\n", fname);
> > +		pr_info("warning: `%s' has both setuid-root and effective capabilities, therefore not raising all capabilities\n",
> > +			fname);

	pr_info_once(etc...

> >  		warned = 1;
> >  	}
> >  }


