Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaHGQft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:35:49 -0400
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:55564 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932086AbaHGQfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:35:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6119:7652:7903:9010:9108:10004:10400:10848:11026:11232:11473:11658:11914:12296:12438:12517:12519:12679:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: woman94_323f90762323e
X-Filterd-Recvd-Size: 2793
Message-ID: <1407429343.2736.28.camel@joe-AO725>
Subject: Re: [PATCH 10/12] staging: lustre: Fix misplaced opening brace
 warnings
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Srikrishan Malik <srikrishanmalik@gmail.com>, greg@kroah.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Aug 2014 09:35:43 -0700
In-Reply-To: <20140807160103.GG4856@mwanda>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
	 <1407345182-709-10-git-send-email-srikrishanmalik@gmail.com>
	 <20140806201813.GE4856@mwanda> <20140807153136.GB4185@mordor.in.ibm.com>
	 <20140807160103.GG4856@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-07 at 19:01 +0300, Dan Carpenter wrote:
> On Thu, Aug 07, 2014 at 09:01:36PM +0530, Srikrishan Malik wrote:
> > On Wed, Aug 06, 2014 at 11:18:13PM +0300, Dan Carpenter wrote:
> > > That looks silly before and after.  Everything is indented in a funny
> > > way.
> > 
> > Is this better:
> > 
> > 	static const ldlm_policy_data_t lookup_policy = {
> > 				.l_inodebits = { MDS_INODELOCK_LOOKUP }
> > 	};
> > 
> 
> That is indented too far.
> 
> Honestly, I think it looks best on one line but in terms of real life we
> can't ignore checkpatch warnings because eventually someone else will
> try to "fix" it to not be on one line.
> 
> This function has the silly thing where the types are in one column and
> the variables are in another.  But then over time inevitably we add more
> variables and nothing is lined up any more.
> 
> I think it's best to move this const variable block to the very front of
> the list.
> 
> req doesn't need to be initialized.
> 
> rc is normally the last variable declared.
> 
> lvb_type should be initialized to LVB_T_NONE instead of zero.
> 
> __u64 should be u64.
> 
> All those changes could be done as one patch titled, "cleanup variable
> declarations in mdc_enqueue()".  There may be other cleanups you could
> do as well.  Look hard.

I think it looks odd to mix named and unnamed
initializers for the typedef and its members.

ldlm_policy_data_t is a union and it could be
explicit instead of a typedef.

Perhaps:
	static const union ldlm_policy_data lookup_policy = {
		.l_inodebits = {
			.bits = MDS_INODELOCK_LOOKUP,
		},
	};

or maybe use another DECLARE_<foo> macro indirection.


