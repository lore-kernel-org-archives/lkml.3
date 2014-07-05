Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbaGED62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 23:58:28 -0400
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:44389 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754086AbaGED61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 23:58:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 20,1.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2328:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3870:3871:3872:3873:4321:5007:7652:8660:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13148:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stick19_66869ea585d08
X-Filterd-Recvd-Size: 1601
Message-ID: <1404532702.6384.36.camel@joe-AO725>
Subject: Re: [PATCH] parisc: Remove sizeof(frame) from call to get_sigframe
From: Joe Perches <joe@perches.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: jejb@parisc-linux.org, deller@gmx.de, tiwai@suse.de, jkosina@suse.cz,
        dave.anglin@bell.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 04 Jul 2014 20:58:22 -0700
In-Reply-To: <1404530457-4739-1-git-send-email-xerofoify@gmail.com>
References: <1404530457-4739-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 23:20 -0400, Nicholas Krause wrote:
> This removes the sizeof(frame) from the call to get_sigframe on line
> 243 in order to fix the call to this function as the sizeof in not
> needed to call this function.

How did you compile this?

arch/parisc/kernel/signal.c:178:get_sigframe(struct k_sigaction *ka, unsigned long sp, size_t frame_size)

> diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
[]
> @@ -240,8 +240,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
[]
> -	/*FIXME: frame_size parameter is unused, remove it. */
> -	frame = get_sigframe(ka, usp, sizeof(*frame));
> +	frame = get_sigframe(ka, usp)

Nichola

