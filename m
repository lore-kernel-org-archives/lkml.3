Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3KSSmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:42:07 -0500
Received: from one.firstfloor.org ([193.170.194.197]:54689 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3KSSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:42:04 -0500
Date: Tue, 19 Nov 2013 19:42:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Expose sysctls for enabling slab/file_cache
 interleaving
Message-ID: <20131119184200.GD29695@two.firstfloor.org>
References: <1384822222-28795-1-git-send-email-andi@firstfloor.org>
 <20131119104203.GB18872@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119104203.GB18872@dhcp22.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 11:42:03AM +0100, Michal Hocko wrote:
> On Mon 18-11-13 16:50:22, Andi Kleen wrote:
> [...]
> > diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> > index cc1b01c..10966f5 100644
> > --- a/include/linux/cpuset.h
> > +++ b/include/linux/cpuset.h
> > @@ -72,12 +72,14 @@ extern int cpuset_slab_spread_node(void);
> >  
> >  static inline int cpuset_do_page_mem_spread(void)
> >  {
> > -	return current->flags & PF_SPREAD_PAGE;
> > +	return (current->flags & PF_SPREAD_PAGE) ||
> > +		sysctl_spread_file_cache;
> >  }
> 
> But this might break applications that explicitly opt out from
> spreading.

What do you mean? There's no such setting at the moment.

They can only enable it.

-Andi
