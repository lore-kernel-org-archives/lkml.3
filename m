Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaHDLMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:12:43 -0400
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:50986 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752561AbaHDLMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:12:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12043:12050:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sheep45_6acabc6e3ea02
X-Filterd-Recvd-Size: 2015
Message-ID: <1407150732.16152.59.camel@joe-AO725>
Subject: Re: [PATCHv2] staging: media: as102: replace custom dprintk() with
 dev_dbg()
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Martin Kepplinger <martink@posteo.de>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.chehab@samsung.com
Date: Mon, 04 Aug 2014 04:12:12 -0700
In-Reply-To: <20140804104016.GQ4804@mwanda>
References: <20140804091023.GP4856@mwanda>
	 <1407147434-27732-1-git-send-email-martink@posteo.de>
	 <20140804104016.GQ4804@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 13:40 +0300, Dan Carpenter wrote:
> On Mon, Aug 04, 2014 at 12:17:14PM +0200, Martin Kepplinger wrote:
[]
> > +	if (dev) {
> > +		dev_dbg(&dev->bus_adap.usb_dev->dev,
> > +		"tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
> > +			params->frequency,
> > +			tune_args->bandwidth,
> > +			tune_args->guard_interval);
> > +	} else {
> > +	pr_debug("as102: tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
> >  			params->frequency,
> >  			tune_args->bandwidth,
> >  			tune_args->guard_interval);
> > +	}
[]
> This isn't indented correctly.  I wish checkpatch.pl would catch that...
> Anyway, the else side can be removed as explained earlier.

checkpatch doesn't warn on any of:

$ cat t.c
static int func(void **bar)
{
	bool b;
			/* test */
		int a[2] = {
			3,
				6
	};

		if (b) {
			b = a[0] == a[1];
	}
			return a[b];
	}
$

I think it'd be better if it would one day
but it doesn't seem as simple as it seems
for checkpatch to do it.

