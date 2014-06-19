Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbaFSCYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:24:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbaFSCYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:24:05 -0400
Date: Wed, 18 Jun 2014 22:23:45 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-ima-user@lists.sourceforge.net, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [Linux-ima-user] [PATCH] audit: fix dangling keywords in
 integrity ima message output
Message-ID: <20140619022345.GJ19353@madcap2.tricolour.ca>
References: <a4cc55c7df380e305cca65d48d3917dcced509e5.1402946960.git.rgb@redhat.com>
 <1403057323.6929.13.camel@dhcp-9-2-203-236.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403057323.6929.13.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/17, Mimi Zohar wrote:
> On Mon, 2014-06-16 at 15:52 -0400, Richard Guy Briggs wrote:
> > Replace spaces in op keyword labels in log output since userspace audit tools
> > can't parse orphaned keywords.
> 
> The patch didn't apply cleanly to linux-integrity/#next.  Please take a
> look at it (linux-integrity/#next-fixes).

Looks like just the change from "const char *op" to "static const char
op[]" in the context.  Looks fine to me.

> thanks,

Thanks Mimi.

> Mimi 
> 
> > Reported-by: Steve Grubb <sgrubb@redhat.com>
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  security/integrity/ima/ima_appraise.c |    2 +-
> >  security/integrity/ima/ima_policy.c   |    6 +++---
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> > index 734e946..61c95af 100644
> > --- a/security/integrity/ima/ima_appraise.c
> > +++ b/security/integrity/ima/ima_appraise.c
> > @@ -214,7 +214,7 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
> >  		hash_start = 1;
> >  	case IMA_XATTR_DIGEST:
> >  		if (iint->flags & IMA_DIGSIG_REQUIRED) {
> > -			cause = "IMA signature required";
> > +			cause = "IMA-signature-required";
> >  			status = INTEGRITY_FAIL;
> >  			break;
> >  		}
> > diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> > index a9c3d3c..dbdc528 100644
> > --- a/security/integrity/ima/ima_policy.c
> > +++ b/security/integrity/ima/ima_policy.c
> > @@ -330,7 +330,7 @@ void __init ima_init_policy(void)
> >  void ima_update_policy(void)
> >  {
> >  	const char *op = "policy_update";
> > -	const char *cause = "already exists";
> > +	const char *cause = "already-exists";
> >  	int result = 1;
> >  	int audit_info = 0;
> > 
> > @@ -654,7 +654,7 @@ ssize_t ima_parse_add_rule(char *rule)
> >  	/* Prevent installed policy from changing */
> >  	if (ima_rules != &ima_default_rules) {
> >  		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
> > -				    NULL, op, "already exists",
> > +				    NULL, op, "already-exists",
> >  				    -EACCES, audit_info);
> >  		return -EACCES;
> >  	}
> > @@ -680,7 +680,7 @@ ssize_t ima_parse_add_rule(char *rule)
> >  	if (result) {
> >  		kfree(entry);
> >  		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
> > -				    NULL, op, "invalid policy", result,
> > +				    NULL, op, "invalid-policy", result,
> >  				    audit_info);
> >  		return result;
> >  	}

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
