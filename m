Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3IKAjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:39:39 -0400
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:39133 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751871Ab3IKAjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:39:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3876:3877:4321:4389:4605:5007:6114:6642:7652:7903:10004:10400:10848:11658:11914:12043:12294:12517:12519:12740:13019:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: box34_8de7e0d1a5a55
X-Filterd-Recvd-Size: 1570
Message-ID: <1378859974.15187.5.camel@joe-AO722>
Subject: Re: Resend: [PATCH 2/2] s390: provide hardware randomness from
 zcrypt card to /dev/random
From: Joe Perches <joe@perches.com>
To: Torsten Duwe <duwe@lst.de>
Cc: tytso@mit.edu, ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <GERALDSC@de.ibm.com>,
        Martin Schwidefsky <martin.schwidefsky@de.ibm.com>
Date: Tue, 10 Sep 2013 17:39:34 -0700
In-Reply-To: <alpine.LNX.2.00.1309041044470.3219@linux.site>
References: <alpine.LNX.2.00.1309041044470.3219@linux.site>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-04 at 10:48 +0200, Torsten Duwe wrote:
[]
> +++ b/drivers/s390/crypto/zcrypt_api.c

> @@ -1141,6 +1144,36 @@ static struct hwrng zcrypt_rng_dev = {
][
> +static int zcrypt_hwrng_fillfn(void *unused)
> +{
> +       long rc;
> +
> +       while (!kthread_should_stop()) {
> +               rc = zcrypt_rng((char *)zcrypt_rng_buffer);
> +               if (rc == -ENODEV || rc == -EINVAL || rc == -ENOMEM) {
> +                       pr_err("zcrypt_rng unavailable: %ld", rc);

please add terminating newlines

			pr_err("zcrypt_rng unavailable: %ld\n", rc);

etc...



