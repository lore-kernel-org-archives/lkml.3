Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaIVDtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:49:09 -0400
Received: from smtprelay0232.hostedemail.com ([216.40.44.232]:54792 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752209AbaIVDtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:49:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3870:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12663:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: milk73_6c64e07b8be43
X-Filterd-Recvd-Size: 1993
Message-ID: <1411357743.2952.25.camel@joe-AO725>
Subject: Re: [PATCH] scripts: checkpatch.pl: Fix existing typedef false
 positive warning
From: Joe Perches <joe@perches.com>
To: Greg Donald <gdonald@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Sun, 21 Sep 2014 20:49:03 -0700
In-Reply-To: <CAO+WgCb0V1NDwYDmn3dVTGUM6d-D8ptUEeABqe-+7QwxLhMM0w@mail.gmail.com>
References: <1411349544-7479-1-git-send-email-gdonald@gmail.com>
	 <1411353090.2952.19.camel@joe-AO725>
	 <CAO+WgCb0V1NDwYDmn3dVTGUM6d-D8ptUEeABqe-+7QwxLhMM0w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-21 at 22:08 -0500, Greg Donald wrote:
> On Sun, Sep 21, 2014 at 9:31 PM, Joe Perches <joe@perches.com> wrote:
> > On Sun, 2014-09-21 at 20:32 -0500, Greg Donald wrote:
> >> Fixing an "open brace '{' following struct go on the same line" error causes a
> >> false positive warning "do not add new typedefs". Fix existing typedef false
> >> positive warning.
> >
> > This doesn't work.
> > The matching deleted line can be any number of lines above.
> 
> But this fixes the most common case:
> 
> -typedef struct ksock_proto
> -{
> +typedef struct ksock_proto {

Meh.  I think people are smart enough to work
out that this is not a new typedef.

> If you're wanting to check more than just $rawlines[$linenr - 3], how
> far above does it make sense to go?  From what I'm seeing the '{' is
> usually on the next line.

It's not the most common case working, it's the
generic case working.

It's in a large block being changed, it doesn't work.
If it's checking a file, there are no "-" lines.



