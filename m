Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaCAQCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 11:02:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaCAQCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 11:02:23 -0500
Date: Sat, 1 Mar 2014 08:02:31 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] PM: define new ASSIGN_*_PM_OPS macros based on
 assign_if
Message-ID: <20140301160231.GA9911@kroah.com>
References: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
 <1393261707-30565-3-git-send-email-joshc@codeaurora.org>
 <20140227190219.GB4421@kroah.com>
 <20140301110633.GA27749@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140301110633.GA27749@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 12:06:33PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > +#define ASSIGN_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
> > > +	.suspend = assign_if_pm_sleep(suspend_fn), \
> > > +	.resume = assign_if_pm_sleep(resume_fn), \
> > > +	.freeze = assign_if_pm_sleep(suspend_fn), \
> > > +	.thaw = assign_if_pm_sleep(resume_fn), \
> > > +	.poweroff = assign_if_pm_sleep(suspend_fn), \
> > > +	.restore = assign_if_pm_sleep(resume_fn),
> > 
> > Ugh, what a mess, really?  Is it that hard to get the #ifdef right in
> > the code?  Why not just always define the functions and then also always
> > have them in the structures, and if the feature isn't enabled, just
> > don't call/use them?
> 
> The functions may not compile with CONFIG_PM disabled. (And #ifdefs in
> the code are considered ugly).
> 
> > Yes, it would cause a _very_ tiny increase in code size if the option is
> > disabled, but really, does anyone ever disable those options becides on
> > the dreaded 'make randconfig' checkers?
> 
> We don't want CONFIG_PM complexity on some embedded systems...

Really, what embedded systems do not want this?

> and it is useful tostart with simple (!PM) system when introducing new
> board.

I'm not saying to disable the option, I'm saying to stop worrying about
saving a few hundred bytes in individual drivers with this crazy #ifdef
and macro mess that no one understands and always gets wrong.

greg k-h
