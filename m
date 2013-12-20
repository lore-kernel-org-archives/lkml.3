Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3LTBfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:35:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905Ab3LTBe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:34:59 -0500
Date: Thu, 19 Dec 2013 20:34:51 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] audit: print error message when fail to create audit
 socket
Message-ID: <20131220013451.GB14944@madcap2.tricolour.ca>
References: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1387295792.23829.86.camel@flatline.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387295792.23829.86.camel@flatline.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/17, Eric Paris wrote:
> On Tue, 2013-12-17 at 11:10 +0800, Gao feng wrote:
> > print the error message and then return -ENOMEM.
> > 
> > Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> 
> Haha.  If it's NULL return.  No no, if it's REALLY null audit_panic().

Wow, who committed *that* crap!?!  :P

Thanks for the catch.

> Acked-by: Eric Paris <eparis@redhat.com>
> > ---
> >  kernel/audit.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 2a0ed0b..041b951 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -1083,12 +1083,11 @@ static int __net_init audit_net_init(struct net *net)
> >  	pr_info("audit: initializing netlink socket in namespace\n");
> >  
> >  	aunet->nlsk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
> > -	if (aunet->nlsk == NULL)
> > -		return -ENOMEM;
> > -	if (!aunet->nlsk)
> > +	if (aunet->nlsk == NULL) {
> >  		audit_panic("cannot initialize netlink socket in namespace");
> > -	else
> > -		aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
> > +		return -ENOMEM;
> > +	}
> > +	aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
> >  	return 0;
> >  }

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
