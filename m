Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaHFV0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:26:09 -0400
Received: from smtprelay0063.hostedemail.com ([216.40.44.63]:37948 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753508AbaHFV0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:26:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2910:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:4605:5007:7652:10004:10400:10848:10967:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13141:13230:13255:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ants75_34fe56df9ee5d
X-Filterd-Recvd-Size: 3190
Message-ID: <1407360362.2736.13.camel@joe-AO725>
Subject: Re: [PATCH 05/12] staging: lustre: Add missing spaces around
 operators and braces.
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>, greg@kroah.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2014 14:26:02 -0700
In-Reply-To: <20140806204528.GB11899@mwanda>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
	 <1407345182-709-5-git-send-email-srikrishanmalik@gmail.com>
	 <20140806201333.GC4856@mwanda> <1407357106.2736.7.camel@joe-AO725>
	 <20140806204528.GB11899@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 23:45 +0300, Dan Carpenter wrote:
> On Wed, Aug 06, 2014 at 01:31:46PM -0700, Joe Perches wrote:
> > On Wed, 2014-08-06 at 23:13 +0300, Dan Carpenter wrote:
> > > On Wed, Aug 06, 2014 at 10:42:55PM +0530, Srikrishan Malik wrote:
> > > > diff --git a/drivers/staging/lustre/lustre/mdc/mdc_reint.c b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
> > []
> > > > @@ -71,7 +71,7 @@ int mdc_resource_get_unused(struct obd_export *exp, const struct lu_fid *fid,
> > > >  			    __u64 bits)
> > > >  {
> > > >  	struct ldlm_namespace *ns = exp->exp_obd->obd_namespace;
> > > > -	ldlm_policy_data_t policy = {{0}};
> > > > +	ldlm_policy_data_t policy = {{0} };
> > > 
> > > That's odd.  Since when is a space required here?  Anyway, put one at
> > > the start too if you're goind to do that.  Or you could do it like:
> > > 
> > > 	ldlm_policy_data_t policy = {};
> > > 
> > > ?
> > 
> > It comes from a pretty old bit of checkpatch:
> > 
> > de7d4f0e (Andy Whitcroft 2007-07-15 23:37:22 -0700 3706) # closing brace should have a space following it when it has anything
> > de7d4f0e (Andy Whitcroft 2007-07-15 23:37:22 -0700 3707) # on the line
> > de7d4f0e (Andy Whitcroft 2007-07-15 23:37:22 -0700 3708)                if ($line =~ /}(?!(?:,|;|\)))\S/) {
> > 
> > Maybe it should have an } added to the test like:
> > 
> > if ($line =~ /}(?!(?:,|;|\)|}))\S/) {
> >
> 
> Yes.  It feels like '}}' is common.

I think so too.  Also, there isn't an equivalent
test for '{{' so warning on '}}' seems silly.

> Also it should ignore \. because this used for:
> 
> ERROR: space required after that close brace '}'
> #118: FILE: ./drivers/gpu/drm/nouveau/core/engine/disp/nva3.c:118:
> +}.base.base;
> 
> Otherwise this test is legit and complains about bad typedefs and
> '}else{' statements.

I don't think \. should be added myself.

Only nouveau uses that style.

I think all of those nouveau uses are not
very nice and they should be changed instead
or the warnings should just be ignored there.

Andy?

