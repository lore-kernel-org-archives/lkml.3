Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3CSCg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:36:29 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48823 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3CSCg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:36:26 -0400
Date: Mon, 18 Mar 2013 19:37:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Li, Fei" <fei.li@intel.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] pm: print the name of failed suspend function for
 platform device
Message-ID: <20130319023743.GB21789@kroah.com>
References: <1363586303.9792.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <20130318160514.GE3887@kroah.com>
 <BEC9F67575FA1E429CA7CF5AE9BE3634421912@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BEC9F67575FA1E429CA7CF5AE9BE3634421912@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 02:05:02AM +0000, Li, Fei wrote:
> > > Print more info when platform device suspend function failed.
> > > Without this patch, we can not get the real platform device suspend
> > > API info.
> > >
> > > Example without this patch:
> > > pm_op(): platform_pm_suspend+0x0/0x50 returns -11
> > > PM: Device power.0 failed to suspend: error -11
> > >
> > > And with this patch:
> > > platform_pm_suspend(): power_suspend+0x0/0x30 returns -11
> > > pm_op(): platform_pm_suspend+0x0/0x80 returns -11
> > > PM: Device power.0 failed to suspend: error -11
> > 
> > How does that help someone out?  One extra line?  What is that going to
> > allow a user to now do?
> >
> Thanks for your comments.
> 
> The intention is to print relatively complete call path for convenience of
> debugging in case of error. With this, we can know the exact name of
> the concrete failed function.

And what was the failed function here, and what would that enable you to
do?

> Besides, currently such information is printed with level KERN_ERR,
> and can be tuned through console_loglevel to avoid the possible impact
> to end user.

Huh?  End users see KERN_ERR.

> Do you think it make sense?

no.  But this is Rafael's file, so I'll defer to him.

greg k-h

