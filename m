Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaHGPbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:31:55 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:65189 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbaHGPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:31:53 -0400
Date: Thu, 7 Aug 2014 21:01:36 +0530
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] staging: lustre: Fix misplaced opening brace
 warnings
Message-ID: <20140807153136.GB4185@mordor.in.ibm.com>
Mail-Followup-To: Srikrishan Malik <srikrishanmalik@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>, greg@kroah.com,
	andreas.dilger@intel.com, oleg.drokin@intel.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
 <1407345182-709-10-git-send-email-srikrishanmalik@gmail.com>
 <20140806201813.GE4856@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806201813.GE4856@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 11:18:13PM +0300, Dan Carpenter wrote:
> On Wed, Aug 06, 2014 at 10:43:00PM +0530, Srikrishan Malik wrote:
> > diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
> > index c03d77c9c5b8..09209171b50c 100644
> > --- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
> > +++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
> > @@ -785,12 +785,12 @@ int mdc_enqueue(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
> >  	__u64		  flags, saved_flags = extra_lock_flags;
> >  	int		    rc;
> >  	struct ldlm_res_id res_id;
> > -	static const ldlm_policy_data_t lookup_policy =
> > -			    { .l_inodebits = { MDS_INODELOCK_LOOKUP } };
> > -	static const ldlm_policy_data_t update_policy =
> > -			    { .l_inodebits = { MDS_INODELOCK_UPDATE } };
> > -	static const ldlm_policy_data_t layout_policy =
> > -			    { .l_inodebits = { MDS_INODELOCK_LAYOUT } };
> > +	static const ldlm_policy_data_t lookup_policy = {
> > +				.l_inodebits = { MDS_INODELOCK_LOOKUP } };
> > +	static const ldlm_policy_data_t update_policy = {
> > +				.l_inodebits = { MDS_INODELOCK_UPDATE } };
> > +	static const ldlm_policy_data_t layout_policy = {
> > +				.l_inodebits = { MDS_INODELOCK_LAYOUT } };
> >  	static const ldlm_policy_data_t getxattr_policy = {
> >  			      .l_inodebits = { MDS_INODELOCK_XATTR } };
> >  	ldlm_policy_data_t const *policy = &lookup_policy;
> 
> That looks silly before and after.  Everything is indented in a funny
> way.

Is this better:

	static const ldlm_policy_data_t lookup_policy = {                       
				.l_inodebits = { MDS_INODELOCK_LOOKUP }         
	};

> 
> regards,
> dan carpenter
