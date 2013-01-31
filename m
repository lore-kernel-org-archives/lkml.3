Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3AaWDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:03:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab3AaWDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:03:52 -0500
Date: Thu, 31 Jan 2013 17:03:47 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 9/9] devcg: propagate local changes down the hierarchy
Message-ID: <20130131220347.GO17632@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131043839.GA14726@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,
On Thu, Jan 31, 2013 at 04:38:39AM +0000, Serge E. Hallyn wrote:
> > @@ -610,9 +770,14 @@ 		case '\0':
> >  		 */
> >  		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
> >  			dev_exception_rm(devcgroup, &ex);
> > -			return 0;
> > +			rc = propagate_exception(devcgroup);
> 
> Let's say the default in both parent A and child B is ALLOW, and both
> have a blacklist entry for "b 8:* rwm".  Now I
> 
> 	echo "b 8:* rwm" > A/devices.allow
> 
> removing the blacklist entry.  Here you are propagating that to the
> child B, which I would argue is actually propagating a new allow to
> a child.  Which you said you wouldn't do.

yep, that's a bug. will fix it up

thanks!

-- 
Aristeu

