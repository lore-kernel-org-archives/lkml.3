Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaHKLgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:36:54 -0400
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:38773 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752894AbaHKLgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:36:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:421:541:599:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2911:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4425:5007:6119:7652:7903:9025:9108:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12679:12740:13069:13311:13357:13845:
X-HE-Tag: tub97_14e244b2bf46
X-Filterd-Recvd-Size: 3200
Message-ID: <1407757007.20795.18.camel@joe-AO725>
Subject: Re: [PATCH 10/12] staging: lustre: Fix misplaced opening brace
 warnings
From: Joe Perches <joe@perches.com>
To: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, greg@kroah.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>,
        Himangi Saraogi <himangi774@gmail.com>
Date: Mon, 11 Aug 2014 04:36:47 -0700
In-Reply-To: <20140811105706.GA17691@mordor.in.ibm.com>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
	 <1407345182-709-10-git-send-email-srikrishanmalik@gmail.com>
	 <20140806201813.GE4856@mwanda> <20140807153136.GB4185@mordor.in.ibm.com>
	 <20140807160103.GG4856@mwanda> <1407429343.2736.28.camel@joe-AO725>
	 <20140811105706.GA17691@mordor.in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-11 at 16:27 +0530, Srikrishan Malik wrote:
> On Thu, Aug 07, 2014 at 09:35:43AM -0700, Joe Perches wrote:
> > On Thu, 2014-08-07 at 19:01 +0300, Dan Carpenter wrote:
> > > On Thu, Aug 07, 2014 at 09:01:36PM +0530, Srikrishan Malik wrote:
> > > > On Wed, Aug 06, 2014 at 11:18:13PM +0300, Dan Carpenter wrote:
> > > > > That looks silly before and after.  Everything is indented in a funny
> > > > > way.
> > > > 
> > > > Is this better:
> > > > 
> > > > 	static const ldlm_policy_data_t lookup_policy = {
> > > > 				.l_inodebits = { MDS_INODELOCK_LOOKUP }
> > > > 	};
> > > > 
> > > 
> > > That is indented too far.
> > > 
> > > Honestly, I think it looks best on one line but in terms of real life we
> > > can't ignore checkpatch warnings because eventually someone else will
> > > try to "fix" it to not be on one line.
[]
> > I think it looks odd to mix named and unnamed
> > initializers for the typedef and its members.
> > 
> > ldlm_policy_data_t is a union and it could be
> > explicit instead of a typedef.
> > 
> > Perhaps:
> > 	static const union ldlm_policy_data lookup_policy = {
> > 		.l_inodebits = {
> > 			.bits = MDS_INODELOCK_LOOKUP,
> > 		},
> > 	};
> > 
> > or maybe use another DECLARE_<foo> macro indirection.
> >
> 
> This patch set is aimed at removing checkpatch issues from files in
> lustre/lustre/mdc.

I think eliminating checkpatch identified issues should
not be the primary goal but a secondary one to the
overall goal of code style uniformity.

Julia Lawall and Himangi Saraogi from coccinelle fame
have created a "detypedef" script that is useful for
structs, perhaps you could extend it for unions and
run it over this lustre code.

For instance:
https://lkml.org/lkml/2014/8/9/104

> Is it ok if I just fix those in this set and post another patch set
> to take care of other issues identified in review?

Up to you.


