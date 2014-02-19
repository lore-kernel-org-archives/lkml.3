Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaBSTlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:41:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbaBSTlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:41:35 -0500
Date: Wed, 19 Feb 2014 14:41:31 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: netdev@oss.sgi.com, davem@davemloft.net, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 3/5] audit: add netlink audit protocol bind to check
 capabilities on multicast join
Message-ID: <20140219194131.GQ16640@madcap2.tricolour.ca>
References: <cover.1392831003.git.rgb@redhat.com>
 <2ead1dbcbb241075feafb2d88656b48761168491.1392831003.git.rgb@redhat.com>
 <1392837336.2165.51.camel@flatline.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392837336.2165.51.camel@flatline.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/19, Eric Paris wrote:
> On Wed, 2014-02-19 at 13:08 -0500, Richard Guy Briggs wrote:
> > Register a netlink per-protocol bind fuction for audit to check userspace
> > process capabilities before allowing a multicast group connection.
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index b5b2f72..f2d2d61 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -1050,10 +1050,20 @@ static void audit_receive(struct sk_buff  *skb)
> >  	mutex_unlock(&audit_cmd_mutex);
> >  }
> >  
> > +/* Run custom bind function on netlink socket group connect or bind requests. */
> > +static int audit_bind(int group)
> > +{
> > +	if (!capable(CAP_AUDIT_READ))
> 
> Not a great idea to use CAP_AUDIT_READ before you define it in patch4

<blush>

> > +		return -EPERM;
> > +
> > +	return 0;
> > +}
> > +
> >  static int __net_init audit_net_init(struct net *net)
> >  {
> >  	struct netlink_kernel_cfg cfg = {
> >  		.input	= audit_receive,
> > +		.bind	= audit_bind,
> >  	};
> >  
> >  	struct audit_net *aunet = net_generic(net, audit_net_id);

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
