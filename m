Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3KSTH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:07:28 -0500
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:40443 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752030Ab3KSTHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:07:20 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2693:2828:2898:2912:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3871:3873:3874:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12679:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: key32_55c706769721
X-Filterd-Recvd-Size: 2461
Message-ID: <1384888035.17783.45.camel@joe-AO722>
Subject: Re: [PATCH v2] power: Replace printks with dev_* and pr_* routines
From: Joe Perches <joe@perches.com>
To: shuah.kh@samsung.com
Cc: len.brown@intel.com, pavel@ucw.cz, gregkh@linuxfoundation.org,
        rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Tue, 19 Nov 2013 11:07:15 -0800
In-Reply-To: <528BB492.8090404@samsung.com>
References: <1384886818-11861-1-git-send-email-shuah.kh@samsung.com>
	 <1384887205.17783.40.camel@joe-AO722> <528BB492.8090404@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 11:57 -0700, Shuah Khan wrote:
> On 11/19/2013 11:53 AM, Joe Perches wrote:
> > On Tue, 2013-11-19 at 11:46 -0700, Shuah Khan wrote:
> >> Replaced printks with dev_* and pr_* routines. Replacing printk in
> >> __suspend_report_result() will require passing in struct device *
> >> pointer from calling routines and this will require changes to
> >> external interface suspend_report_result() which is used by several
> >> drivers. Hence, this one instance is replaced by pr_err().
> > []
> >> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > []
> >> @@ -1308,9 +1308,8 @@ int dpm_prepare(pm_message_t state)
> >>   				error = 0;
> >>   				continue;
> >>   			}
> >> -			printk(KERN_INFO "PM: Device %s not prepared "
> >> -				"for power transition: code %d\n",
> >> -				dev_name(dev), error);
> >> +			dev_info("PM: not prepared for power transition: ",
> >> +				 "code %d\n", error);
> >
> > Shuah, you have to make sure the files modified by
> > your patches compile successfully before sending
> > patches like this.
> Oops. I did compile. Missed the warning. Sorry about that.

btw:

When you're doing patches like this, not bugfixes,
not something that's going to be applied to current
or stable, please make them against -next and not
against Linus' tree.

Also, I would make the larger change that modifies
all the drivers like I suggested.  What you've done
I think is a half-measure and is incomplete.

cheers, Joe

