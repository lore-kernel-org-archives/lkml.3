Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935029AbaBDVVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:21:21 -0500
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:44780 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933627AbaBDVVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:21:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3870:3871:4321:4560:5007:7652:7901:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: eyes89_7dba8649ee649
X-Filterd-Recvd-Size: 1998
Message-ID: <1391548862.2538.34.camel@joe-AO722>
Subject: Re: [PATCH v7 2/3] trivial: PM / Hibernate: clean up checkpatch in
 hibernate.c
From: Joe Perches <joe@perches.com>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Tue, 04 Feb 2014 13:21:02 -0800
In-Reply-To: <1391546631-7715-3-git-send-email-sebastian.capella@linaro.org>
References: <1391546631-7715-1-git-send-email-sebastian.capella@linaro.org>
	 <1391546631-7715-3-git-send-email-sebastian.capella@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-04 at 12:43 -0800, Sebastian Capella wrote:
> Checkpatch reports several warnings in hibernate.c
> printk use removed, long lines wrapped, whitespace cleanup,
> extend short msleeps, while loops on two lines.
[]
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
[]
> @@ -765,7 +762,7 @@ static int software_resume(void)
>  	if (isdigit(resume_file[0]) && resume_wait) {
>  		int partno;
>  		while (!get_gendisk(swsusp_resume_device, &partno))
> -			msleep(10);
> +			msleep(20);

What good is changing this from 10 to 20?

> @@ -776,8 +773,9 @@ static int software_resume(void)
>  		wait_for_device_probe();
>  
>  		if (resume_wait) {
> -			while ((swsusp_resume_device = name_to_dev_t(resume_file)) == 0)
> -				msleep(10);
> +			while ((swsusp_resume_device =
> +					name_to_dev_t(resume_file)) == 0)
> +				msleep(20);

here too.


