Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbaHGQBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:01:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44630 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaHGQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:01:32 -0400
Date: Thu, 7 Aug 2014 19:01:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Srikrishan Malik <srikrishanmalik@gmail.com>, greg@kroah.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] staging: lustre: Fix misplaced opening brace
 warnings
Message-ID: <20140807160103.GG4856@mwanda>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
 <1407345182-709-10-git-send-email-srikrishanmalik@gmail.com>
 <20140806201813.GE4856@mwanda>
 <20140807153136.GB4185@mordor.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807153136.GB4185@mordor.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 09:01:36PM +0530, Srikrishan Malik wrote:
> On Wed, Aug 06, 2014 at 11:18:13PM +0300, Dan Carpenter wrote:
> > That looks silly before and after.  Everything is indented in a funny
> > way.
> 
> Is this better:
> 
> 	static const ldlm_policy_data_t lookup_policy = {
> 				.l_inodebits = { MDS_INODELOCK_LOOKUP }
> 	};
> 

That is indented too far.

Honestly, I think it looks best on one line but in terms of real life we
can't ignore checkpatch warnings because eventually someone else will
try to "fix" it to not be on one line.

This function has the silly thing where the types are in one column and
the variables are in another.  But then over time inevitably we add more
variables and nothing is lined up any more.

I think it's best to move this const variable block to the very front of
the list.

req doesn't need to be initialized.

rc is normally the last variable declared.

lvb_type should be initialized to LVB_T_NONE instead of zero.

__u64 should be u64.

All those changes could be done as one patch titled, "cleanup variable
declarations in mdc_enqueue()".  There may be other cleanups you could
do as well.  Look hard.

regards,
dan carpenter

