Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825Ab3JPWkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:40:09 -0400
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:47799 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761720Ab3JPWkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:40:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3873:4321:5007:6117:7652:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: page91_1d257e3633c05
X-Filterd-Recvd-Size: 1544
Message-ID: <1381963198.22110.73.camel@joe-AO722>
Subject: Re: [PATCH v2] drivers: input: mouse: Remove useless casting in
 cypress_ps2.c
From: Joe Perches <joe@perches.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: dmitry.torokhov@gmail.com, dudl@cypress.com, kamal@canonical.com,
        mario_limonciello@dell.com, git@status.e4ward.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com
Date: Wed, 16 Oct 2013 15:39:58 -0700
In-Reply-To: <1381962675-26876-1-git-send-email-geyslan@gmail.com>
References: <1381962675-26876-1-git-send-email-geyslan@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 19:31 -0300, Geyslan G. Bem wrote:
> Get rid of unnecessary (void *) casting in 'cypress_init' function.
[]
> diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
[]
> @@ -680,7 +680,7 @@ int cypress_init(struct psmouse *psmouse)
>  	struct cytp_data *cytp;
>  
>  	cytp = (struct cytp_data *)kzalloc(sizeof(struct cytp_data), GFP_KERNEL);
> -	psmouse->private = (void *)cytp;
> +	psmouse->private = cytp;

If you are going to remove useless casts, please
also remove the unnecessary kzalloc cast too.


