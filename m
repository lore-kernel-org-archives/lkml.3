Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbaGBQaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:30:22 -0400
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:42564 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756283AbaGBQaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:30:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3874:4321:5007:7652:7875:7903:9164:10004:10400:10848:11026:11232:11658:11914:12114:12296:12517:12519:12740:13069:13141:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: farm47_5941fec75895f
X-Filterd-Recvd-Size: 2320
Message-ID: <1404318611.14624.80.camel@joe-AO725>
Subject: Re: [PATCH 3/6] lib80211: re-use string_escape_mem_any_np()
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 02 Jul 2014 09:30:11 -0700
In-Reply-To: <1404309961.5102.35.camel@smile.fi.intel.com>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404307229-19186-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404308611.14624.78.camel@joe-AO725>
	 <1404309961.5102.35.camel@smile.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 17:06 +0300, Andy Shevchenko wrote:
> On Wed, 2014-07-02 at 06:43 -0700, Joe Perches wrote:
> > On Wed, 2014-07-02 at 16:20 +0300, Andy Shevchenko wrote:
> > > In kernel we have function to escape a given string. Let's use it instead of
> > > custom approach.
> > > 
> > > This fixes a bug. The current implementation wrongly prints octal numbers: only
> > > two first digits are used in case when 3 are required and the rest of the
> > > string ends up cut off.
> 
> []
> 
> > This code looks like it was adapted from the old print_mac
> > ethernet code that was eventually replaced by a vsprintf
> > pointer extension %pM
> > 
> > So a better way to do this might be to add and use yet
> > another vsprintf %p<foo> extension for ssids.
> 
> Might be, but it
>  - doesn't reduce necessity of string_escape_mem (not only ssid are
> escaped in kernel)
>  - prevents user to choose a rule what exactly their would like to
> escape (look at the other patches against ssid escaping)
> 

%pE<FLAGS> would allow the same arbitrary combinations
of your flags.


