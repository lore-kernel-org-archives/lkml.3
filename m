Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3J3Tls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:41:48 -0400
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:59876 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754634Ab3J3Tlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:41:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:2893:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4321:4605:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13019:13069:13071:13161:13229:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: taste79_ed8788120f4d
X-Filterd-Recvd-Size: 1947
Message-ID: <1383162100.9435.39.camel@joe-AO722>
Subject: Re: [PATCH 1/2] tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
From: Joe Perches <joe@perches.com>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>,
        stable@vger.kernel.org
Date: Wed, 30 Oct 2013 12:41:40 -0700
In-Reply-To: <201310302035.36579.PeterHuewe@gmx.de>
References: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de>
	 <1383095144.12439.41.camel@joe-AO722>
	 <201310302035.36579.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 20:35 +0100, Peter Hüwe wrote:
> Hi Joe, Jason

Hi Peter.

> > lib/string.c:strcmp returns only -1,0,1
> > so that's what the arch versions should do too.
> > However, arch implementations do vary...
[]
> I did not pay attention to where cscope did send me 
> - it was arch/x86/boot/string.c which implements it as 
> 
>         while (*s1 || *s2) {
>                 delta = *s2 - *s1;
>                 if (delta)
>                         return delta;
>                 s1++;
>                 s2++;
>         }
> 
> Although I know that this is not used here, 
> it differs from the version in lib. (Maybe worth changing?)

The arch/... assembly versions don't always
return -1, 0, 1 so I don't think it's worth
it to change all of those.



