Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaF3VJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:09:10 -0400
Received: from smtprelay0086.hostedemail.com ([216.40.44.86]:54607 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752266AbaF3VJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:09:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3872:3873:4321:5007:6119:6120:7652:7903:8603:10004:10400:10848:10967:11232:11658:11914:12043:12517:12519:12555:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: burn23_4f95697afe53c
X-Filterd-Recvd-Size: 1823
Message-ID: <1404162545.2717.14.camel@joe-AO725>
Subject: Re: [RFC 1/1] proc: constify seq_operations
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Date: Mon, 30 Jun 2014 14:09:05 -0700
In-Reply-To: <20140630135744.51ebff73c7e396f1c50f0c81@linux-foundation.org>
References: <1404154997-15490-1-git-send-email-fabf@skynet.be>
	 <20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org>
	 <1404161370.2717.10.camel@joe-AO725>
	 <20140630135744.51ebff73c7e396f1c50f0c81@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 13:57 -0700, Andrew Morton wrote:
> On Mon, 30 Jun 2014 13:49:30 -0700 Joe Perches <joe@perches.com> wrote:

> > It moves ~100 bytes from data to text

> > $ size kernel/user_namespace.o*
> >    text    data     bss     dec     hex filename
> >    6676    3107    2248   12031    2eff kernel/user_namespace.o.new
> >    6580    3211    2248   12039    2f07 kernel/user_namespace.o.old

> doh, I only looked at base.o.
> 
> I added this to the changelog.  It should have been there originally,
> please.
> 
>    text    data     bss     dec     hex filename
>    6817     404    1984    9205    23f5 kernel/user_namespace.o-before
>    6913     308    1984    9205    23f5 kernel/user_namespace.o-after

The delta in our object sizes in curious.

x86-64 allyesconfig here.
What gcc version for you?


