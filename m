Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaIJOUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:20:22 -0400
Received: from smtprelay0176.hostedemail.com ([216.40.44.176]:41617 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752554AbaIJOUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:20:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:2917:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:4321:4605:5007:6119:7652:7903:10004:10400:10450:10455:10848:11026:11232:11233:11658:11914:12043:12296:12517:12519:12740:13069:13071:13095:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sky51_7608bb4fc0c3a
X-Filterd-Recvd-Size: 2489
Message-ID: <1410358807.24028.44.camel@joe-AO725>
Subject: Re: [PATCH net-next 2/5] ceph: Convert pr_warning to pr_warn
From: Joe Perches <joe@perches.com>
To: Ilya Dryomov <ilya.dryomov@inktank.com>
Cc: netdev@vger.kernel.org, Sage Weil <sage@inktank.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 10 Sep 2014 07:20:07 -0700
In-Reply-To: <CALFYKtCiGXhMZ-f0B=TGSNGZCng8NVYWCV-wwOHq3xPdKO+-Kw@mail.gmail.com>
References: <cover.1410322181.git.joe@perches.com>
	 <714b7551f5a6ea5e721fed705568a39eeae4623b.1410322181.git.joe@perches.com>
	 <CALFYKtCiGXhMZ-f0B=TGSNGZCng8NVYWCV-wwOHq3xPdKO+-Kw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 16:38 +0400, Ilya Dryomov wrote:
> On Wed, Sep 10, 2014 at 8:17 AM, Joe Perches <joe@perches.com> wrote:
> > Use the more common pr_warn.
> >
> > Other miscellanea:
> >
> > o Coalesce formats
> > o Realign arguments
[]
> > diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
[]
> > @@ -2828,8 +2828,9 @@ static void con_work(struct work_struct *work)
> >   */
> >  static void con_fault(struct ceph_connection *con)
> >  {
> > -       pr_warning("%s%lld %s %s\n", ENTITY_NAME(con->peer_name),
> > -              ceph_pr_addr(&con->peer_addr.in_addr), con->error_msg);
> > +       pr_warn("%s%lld %s %s\n",
> > +               ENTITY_NAME(con->peer_name),
> > +               ceph_pr_addr(&con->peer_addr.in_addr), con->error_msg);
> 
> Just wondering, why did you move ENITITY_NAME argument to the next
> line?  I see you are doing this pretty consistently.  Is this a style
> guideline or something?

Hello Ilya.

It's just a personal preference to have the
formats on one line and its arguments on
another when the format and its arguments
don't fit 80 columns.

Maximal 80 column fill isn't always easy for me
to read.

I find it easier to match formats and arguments
when scanning because my eye doesn't have to
scan to the end of the format line.

If you don't like it, it's your code.  Change it.

cheers, Joe

