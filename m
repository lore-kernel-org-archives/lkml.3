Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbbANImN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:42:13 -0500
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:39958 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755979AbbANIl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:41:27 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2551:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3873:3874:4321:4605:5007:6261:7903:9108:10004:10400:10848:11026:11232:11658:11914:12043:12050:12296:12517:12519:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: join97_80c54f805ce24
X-Filterd-Recvd-Size: 2325
Message-ID: <1421224883.2847.3.camel@perches.com>
Subject: Re: [PATCH] staging: android: fix coding style error
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Patrick Boettcher <patrick.boettcher@posteo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2015 00:41:23 -0800
In-Reply-To: <1839300.4mCDOMkO8E@wuerfel>
References: <1421223642-4465-1-git-send-email-patrick.boettcher@posteo.de>
	 <1839300.4mCDOMkO8E@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-14 at 09:32 +0100, Arnd Bergmann wrote:
> On Wednesday 14 January 2015 09:20:42 Patrick Boettcher wrote:
> > diff --git a/drivers/staging/android/sync_debug.c b/drivers/staging/android/sync_debug.c
[]
> > @@ -96,7 +96,8 @@ static void sync_print_pt(struct seq_file *s, struct sync_pt *pt, bool fence)
> >                    sync_status_str(status));
> >  
> >         if (status <= 0) {
> > -               struct timespec64 ts64 = ktime_to_timespec64(pt->base.timestamp);
> > +               struct timespec64 ts64 =
> > +                   ktime_to_timespec64(pt->base.timestamp);
> >  
> >                 seq_printf(s, "@%lld.%09ld", (s64)ts64.tv_sec, ts64.tv_nsec);
> >         }
> > 
> 
> You are not really improving readability by just wrapping the line
> arbitrarily though.
> 
> If you're offended by the long line, better rework the code so the long
> line is not needed.

Generally the best way to do that is to separate
the declaration from the initialization like:

	if (status <= 0) {
		struct timespec64 ts64;

		ts64 = ktime_to_timespec64(pt->base.timestamp);
		seq_printf(s, "@%lld.%09ld", (s64)ts64.tv_sec, ts64.tv_nsec);
	}


