Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaHKK5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:57:24 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:56980 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaHKK5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:57:23 -0400
Date: Mon, 11 Aug 2014 16:27:06 +0530
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, greg@kroah.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] staging: lustre: Fix misplaced opening brace
 warnings
Message-ID: <20140811105706.GA17691@mordor.in.ibm.com>
Mail-Followup-To: Srikrishan Malik <srikrishanmalik@gmail.com>,
	Joe Perches <joe@perches.com>,
	Dan Carpenter <dan.carpenter@oracle.com>, greg@kroah.com,
	andreas.dilger@intel.com, oleg.drokin@intel.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
 <1407345182-709-10-git-send-email-srikrishanmalik@gmail.com>
 <20140806201813.GE4856@mwanda>
 <20140807153136.GB4185@mordor.in.ibm.com>
 <20140807160103.GG4856@mwanda>
 <1407429343.2736.28.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407429343.2736.28.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 09:35:43AM -0700, Joe Perches wrote:
> On Thu, 2014-08-07 at 19:01 +0300, Dan Carpenter wrote:
> > On Thu, Aug 07, 2014 at 09:01:36PM +0530, Srikrishan Malik wrote:
> > > On Wed, Aug 06, 2014 at 11:18:13PM +0300, Dan Carpenter wrote:
> > > > That looks silly before and after.  Everything is indented in a funny
> > > > way.
> > > 
> > > Is this better:
> > > 
> > > 	static const ldlm_policy_data_t lookup_policy = {
> > > 				.l_inodebits = { MDS_INODELOCK_LOOKUP }
> > > 	};
> > > 
> > 
> > That is indented too far.
> > 
> > Honestly, I think it looks best on one line but in terms of real life we
> > can't ignore checkpatch warnings because eventually someone else will
> > try to "fix" it to not be on one line.
> > 
> > This function has the silly thing where the types are in one column and
> > the variables are in another.  But then over time inevitably we add more
> > variables and nothing is lined up any more.
> > 
> > I think it's best to move this const variable block to the very front of
> > the list.
> > 
> > req doesn't need to be initialized.
> > 
> > rc is normally the last variable declared.
> > 
> > lvb_type should be initialized to LVB_T_NONE instead of zero.
> > 
> > __u64 should be u64.
> > 
> > All those changes could be done as one patch titled, "cleanup variable
> > declarations in mdc_enqueue()".  There may be other cleanups you could
> > do as well.  Look hard.
> 
> I think it looks odd to mix named and unnamed
> initializers for the typedef and its members.
> 
> ldlm_policy_data_t is a union and it could be
> explicit instead of a typedef.
> 
> Perhaps:
> 	static const union ldlm_policy_data lookup_policy = {
> 		.l_inodebits = {
> 			.bits = MDS_INODELOCK_LOOKUP,
> 		},
> 	};
> 
> or maybe use another DECLARE_<foo> macro indirection.
>

This patch set is aimed at removing checkpatch issues from files in
lustre/lustre/mdc.

Is it ok if I just fix those in this set and post another patch set
to take care of other issues identified in review?

- removing typedef for ldlm_policy_data_t will touch many other
files/dirs which were not initially targeted for this patch set.
- There can be a separate patch to remove __u64.

