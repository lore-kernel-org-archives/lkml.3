Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3JHAMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:12:32 -0400
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:34792 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751750Ab3JHAM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:12:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3868:3872:3873:4321:4605:5007:6248:7652:10004:10400:10848:11232:11473:11658:11914:12517:12519:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bell59_1569f48935b1b
X-Filterd-Recvd-Size: 1877
Message-ID: <1381191145.2081.230.camel@joe-AO722>
Subject: Re: [PATCH] 9p: unsigned/signed wrap in p9/unix modes.
From: Joe Perches <joe@perches.com>
To: Geyslan =?ISO-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, rminnich@sandia.gov,
        lucho@ionkov.net, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, kernel-br <kernel-br@googlegroups.com>
Date: Mon, 07 Oct 2013 17:12:25 -0700
In-Reply-To: <CAGG-pURYyCV4waC8Z+5qAd1mAB2ZHhEkRaGspFuyEDrvj_dTdQ@mail.gmail.com>
References: <1381184340-11190-1-git-send-email-geyslan@gmail.com>
	 <1381185204.2081.221.camel@joe-AO722>
	 <CAGG-pURYyCV4waC8Z+5qAd1mAB2ZHhEkRaGspFuyEDrvj_dTdQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 21:09 -0300, Geyslan Gregório Bem wrote:
> Joe,
> 
> Thank you for reply.
> 
> What do you think about:
> 
>                  strncpy(ext, stat->extension, sizeof(ext));
> +                 if (sscanf(ext, "%c %u %u", &type, &major, &minor) < 3) {
> +                                  p9_debug(P9_DEBUG_ERROR,
> +                                  "It's necessary define type, major
> and minor values when using P9_DMDEVICE");
> +                                  return res;
> +                 }
>                  switch (type) {
>                  case 'c':
>                          res |= S_IFCHR;
>                          break;
> ...
>                  *rdev = MKDEV(major, minor);

I think the plan 9 folk should figure out what's right.


