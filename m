Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab3LHWRO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 17:17:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab3LHWRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 17:17:10 -0500
Date: Sun, 8 Dec 2013 17:17:03 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] smack: call WARN_ONCE() instead of calling
 audit_log_start()
Message-ID: <20131208221703.GB10279@madcap2.tricolour.ca>
References: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
 <f18b900087454601b1431183f705f61acd4932c7.1386206544.git.rgb@redhat.com>
 <52A21A38.40802@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A21A38.40802@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 10:40:56AM -0800, Casey Schaufler wrote:
> On 12/4/2013 6:45 PM, Richard Guy Briggs wrote:
> > Remove the call to audit_log() (which call audit_log_start()) and deal with
> > the errors in the caller, logging only once if the condition is met.  Calling
> > audit_log_start() in this location makes buffer allocation and locking more
> > complicated in the calling tree (audit_filter_user()).
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> 
> I'm not opposed to this change, but have you actually tried it?

No, do you have concerns?

It is a projection based on the selinux_audit_match_rule() patch in the
same set.

> > ---
> >  security/smack/smack_lsm.c |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> > index 8825375..185e2e7 100644
> > --- a/security/smack/smack_lsm.c
> > +++ b/security/smack/smack_lsm.c
> > @@ -3615,9 +3615,8 @@ static int smack_audit_rule_match(u32 secid, u32 field, u32 op, void *vrule,
> >  	struct smack_known *skp;
> >  	char *rule = vrule;
> >  
> > -	if (!rule) {
> > -		audit_log(actx, GFP_ATOMIC, AUDIT_SELINUX_ERR,
> > -			  "Smack: missing rule\n");
> > +	if (unlikely(!rule)) {
> > +		WARN_ONCE(1, "Smack: missing rule\n");
> >  		return -ENOENT;
> >  	}
> >  
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
