Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaHFUqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:46:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27524 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaHFUpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:45:51 -0400
Date: Wed, 6 Aug 2014 23:45:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>, greg@kroah.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] staging: lustre: Add missing spaces around
 operators and braces.
Message-ID: <20140806204528.GB11899@mwanda>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
 <1407345182-709-5-git-send-email-srikrishanmalik@gmail.com>
 <20140806201333.GC4856@mwanda>
 <1407357106.2736.7.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407357106.2736.7.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 01:31:46PM -0700, Joe Perches wrote:
> On Wed, 2014-08-06 at 23:13 +0300, Dan Carpenter wrote:
> > On Wed, Aug 06, 2014 at 10:42:55PM +0530, Srikrishan Malik wrote:
> > > diff --git a/drivers/staging/lustre/lustre/mdc/mdc_reint.c b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
> []
> > > @@ -71,7 +71,7 @@ int mdc_resource_get_unused(struct obd_export *exp, const struct lu_fid *fid,
> > >  			    __u64 bits)
> > >  {
> > >  	struct ldlm_namespace *ns = exp->exp_obd->obd_namespace;
> > > -	ldlm_policy_data_t policy = {{0}};
> > > +	ldlm_policy_data_t policy = {{0} };
> > 
> > That's odd.  Since when is a space required here?  Anyway, put one at
> > the start too if you're goind to do that.  Or you could do it like:
> > 
> > 	ldlm_policy_data_t policy = {};
> > 
> > ?
> 
> It comes from a pretty old bit of checkpatch:
> 
> de7d4f0e (Andy Whitcroft 2007-07-15 23:37:22 -0700 3706) # closing brace should have a space following it when it has anything
> de7d4f0e (Andy Whitcroft 2007-07-15 23:37:22 -0700 3707) # on the line
> de7d4f0e (Andy Whitcroft 2007-07-15 23:37:22 -0700 3708)                if ($line =~ /}(?!(?:,|;|\)))\S/) {
> 
> Maybe it should have an } added to the test like:
> 
> if ($line =~ /}(?!(?:,|;|\)|}))\S/) {
>

Yes.  It feels like '}}' is common.

Also it should ignore \. because this used for:

ERROR: space required after that close brace '}'
#118: FILE: ./drivers/gpu/drm/nouveau/core/engine/disp/nva3.c:118:
+}.base.base;

Otherwise this test is legit and complains about bad typedefs and
'}else{' statements.

regards,
dan carpenter
