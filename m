Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3IXQYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:24:36 -0400
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:45019 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751038Ab3IXQYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:24:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2110:2194:2198:2199:2200:2393:2551:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:3873:4037:4250:4321:5007:7556:7652:7901:7903:8531:9036:10004:10400:10848:11232:11658:11914:12050:12296:12517:12519:12663:12740:13069:13071:13161:13229:13311:13357:13618,0,RBL:n
X-HE-Tag: stew65_7ed4b082e0711
X-Filterd-Recvd-Size: 3252
Message-ID: <1380039870.3575.90.camel@joe-AO722>
Subject: Re: [PATCH v5 1/4] media: s5p-tv: Replace mxr_ macro by default dev_
From: Joe Perches <joe@perches.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        m.chehab@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Sep 2013 09:24:30 -0700
In-Reply-To: <52418B1C.6030600@samsung.com>
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
	 <1379775649-6331-2-git-send-email-m.krawczuk@partner.samsung.com>
	 <52405519.3020504@samsung.com> <13162989.WhfDRzW6dg@amdc1032>
	 <1379958282.3575.31.camel@joe-AO722> <52418B1C.6030600@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 14:52 +0200, Tomasz Stanislawski wrote:
> On 09/23/2013 07:44 PM, Joe Perches wrote:
> > On Mon, 2013-09-23 at 17:48 +0200, Bartlomiej Zolnierkiewicz wrote:
> >> On Monday, September 23, 2013 04:50:01 PM Tomasz Stanislawski wrote:
> >>> May I ask what is the rationale for this patch?
> >>> To reduce a few lines of code?
> >> This patch makes source code more generic-like and easier to follow (mxd_r*
> >> macros currently only obfuscate the code and make them harder to read for
> >> everybody, maybe besides the original driver author ;). Removal of few
> >> superfluous lines of code is just a bonus.
> > I don't see any significant issue with this change.
> > Using generic mechanisms is good.
> Hi Joe,

Hi Tomasz

> Sorry for flaming

Sorry, but I didn't feel any heat.
Maybe I'm too far from the fire.
I'll get closer.

>  but please let me explain reasons of my opposition to this patch.

I don't have an issue either way.
I prefer using localized logging macros like mxd_<level>
but I don't much care if actual maintainers want to use
the generic style or a localized style.

> 4. I looked for other files where macro for dev_err is used.
> I tried following shell command on v3.12-rc2.
> 
> git grep -A1 "_err(" | grep -A1 '#define' | grep -B1 "dev_err"
> 
> then processing results using
> grep -v "^--" | cut -d: -f 1 | sort -u | wc

You'll have to look farther then 1 line for dev_err
There are uses like:

#define foo_err(pointer, fmt, ...)			\
do {							\
	if (something)					\
		dev_err(pointer->something, ...);	\
} while (0)

> Currently, due to mentioned reason the patch is not a cleanup-up for me.
> And since I am still a maintainer of this god-forgotten driver I am
> going NACK this patch because it makes my work more difficult and because
> this patch provides only (if any) relative aesthetic gain.

Good for you.
Maintainer preference trumps global style consistency.

cheers, Joe

