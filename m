Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaCEWBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:01:05 -0500
Received: from smtprelay0140.hostedemail.com ([216.40.44.140]:33336 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756720AbaCEWBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:01:03 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3871:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12740:13069:13095:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: net29_7d3e4f696c05d
X-Filterd-Recvd-Size: 1621
Message-ID: <1394056859.12070.23.camel@joe-AO722>
Subject: Re: [PATCH 3.13] regulator: core: Change dummy supplies error
 message to a warning
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: lgirdwood@gmail.com, broonie@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, Mark Brown <broonie@linaro.org>
Date: Wed, 05 Mar 2014 14:00:59 -0800
In-Reply-To: <1394054987-4743-1-git-send-email-shuah.kh@samsung.com>
References: <1394054987-4743-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 14:29 -0700, Shuah Khan wrote:
> Change "dummy supplies not allowed" error message to warning instead,
> as this is a just warning message with no change to the behavior.
[]
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
[]
> @@ -1359,7 +1359,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>  		rdev = dummy_regulator_rdev;
>  		goto found;
>  	} else {
> -		dev_err(dev, "dummy supplies not allowed\n");
> +		dev_warn(dev, "dummy supplies not allowed\n");

What does this mean anyway?

Would it be better to emit the calling function too with
%pf, __builtin_return_address(0)?

