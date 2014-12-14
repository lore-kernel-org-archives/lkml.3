Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaLNWw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:52:57 -0500
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:59275 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750751AbaLNWwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:52:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3866:3867:3871:3872:4321:5007:6261:7903:8957:10004:10400:10848:11026:11232:11658:11914:12043:12438:12485:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: thing02_52707dfa4da33
X-Filterd-Recvd-Size: 1864
Message-ID: <1418597564.2674.1.camel@perches.com>
Subject: Re: [PATCH] staging: vt6655: wmgr.c:  Fix for possible null pointer
 dereference
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Guillaume Clement <gclement@baobob.org>,
        Guido =?ISO-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Himangi Saraogi <himangi774@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Dec 2014 14:52:44 -0800
In-Reply-To: <1418596940-24915-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1418596940-24915-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-14 at 23:42 +0100, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> Was largely found by using a static code analysis program called cppcheck.
[]
> diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
[]
> @@ -4391,7 +4391,7 @@ bAdd_PMKID_Candidate(
>  	unsigned int ii = 0;
>  
>  	pr_debug("bAdd_PMKID_Candidate START: (%d)\n",
> -		 (int)pDevice->gsPMKIDCandidate.NumCandidates);
> +		(int)(pDevice ? pDevice->gsPMKIDCandidate.NumCandidates : 0));

This is a function tracing printk.
I think it's better to just remove it.



