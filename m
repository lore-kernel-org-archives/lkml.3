Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaAHDa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 22:30:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbaAHDaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 22:30:21 -0500
Date: Tue, 7 Jan 2014 22:30:05 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, eparis@redhat.com
Subject: Re: [PATCH 1/2] audit: print error message when fail to create audit
 socket
Message-ID: <20140108033005.GD13431@madcap2.tricolour.ca>
References: <1387249842-27793-1-git-send-email-gaofeng@cn.fujitsu.com>
 <20140107165335.c276557412291786d745e0ab@linux-foundation.org>
 <52CCA748.4080709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CCA748.4080709@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/08, Gao feng wrote:
> On 01/08/2014 08:53 AM, Andrew Morton wrote:
> > On Tue, 17 Dec 2013 11:10:41 +0800 Gao feng <gaofeng@cn.fujitsu.com> wrote:
> > 
> >> print the error message and then return -ENOMEM.
> >>
> >> ...
> >>
> >> --- a/kernel/audit.c
> >> +++ b/kernel/audit.c
> >> @@ -1083,12 +1083,11 @@ static int __net_init audit_net_init(struct net *net)
> >>  	pr_info("audit: initializing netlink socket in namespace\n");
> >>  
> >>  	aunet->nlsk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
> >> -	if (aunet->nlsk == NULL)
> >> -		return -ENOMEM;
> >> -	if (!aunet->nlsk)
> >> +	if (aunet->nlsk == NULL) {
> >>  		audit_panic("cannot initialize netlink socket in namespace");
> >> -	else
> >> -		aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
> >> +		return -ENOMEM;
> >> +	}
> >> +	aunet->nlsk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
> >>  	return 0;
> >>  }
> > 
> > What kernel version are these against?  Something ancient, I expect -
> > audit_net_init() doesn't exist.
> > 
> > Please check current kernels, redo and resend the patches if anything
> > needs changing?
> 
> This patch is against Richard Guy Briggs's audit tree. the current kernel
> doesn't have this problem.
> 
> BTW, Richard & Eric, when do you plan to push these changes to the upstream?
> there are a lot of changes in Richard's tree.

Planning for this merge window.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
