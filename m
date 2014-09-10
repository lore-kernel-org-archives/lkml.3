Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaIJS2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:28:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaIJS2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:28:03 -0400
Date: Wed, 10 Sep 2014 11:27:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Maciej Matraszek <m.matraszek@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] PM / Domains: add debugfs listing of struct
 generic_pm_domain-s
Message-ID: <20140910182712.GE14642@kroah.com>
References: <1410348536-15201-1-git-send-email-m.matraszek@samsung.com>
 <20140910144340.GA17967@kroah.com>
 <1410363493.15593.26.camel@AMDC723>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410363493.15593.26.camel@AMDC723>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 05:38:13PM +0200, Maciej Matraszek wrote:
> Hi Greg,
> thanks for your reply!
> 
> > > +static int __init pm_genpd_debug_init(void)
> > > +{
> > > +	struct dentry *d;
> > > +
> > > +	pm_genpd_debugfs_dir = debugfs_create_dir("pm_genpd", NULL);
> > > +
> > > +	/* No debugfs */
> > > +	if (IS_ERR(pm_genpd_debugfs_dir))
> > > +		return PTR_ERR(pm_genpd_debugfs_dir);
> > 
> > You shouldn't care at all, just do this check:
> > 
> > > +	if (!pm_genpd_debugfs_dir)
> > > +		return -ENOMEM;
> > 
> > And all will be fine, because:
> > 
> > > +	d = debugfs_create_file("pm_genpd_summary", S_IRUGO,
> > > +			pm_genpd_debugfs_dir, NULL, &pm_genpd_summary_fops);
> > 
> > That call will resolve away to nothing if debugfs is not enabled, and it
> > doesn't make much sense to do anything with an "error" of no debugfs.
> 
> Great! I'll fix this bizarre double check.
> 
> > 
> > > +	if (!d)
> > > +		return -ENOMEM;
> > > +
> > > +	return 0;
> > > +}
> > > +late_initcall(pm_genpd_debug_init);
> > > +#endif /* CONFIG_PM_ADVANCED_DEBUG */
> > 
> > No tear-down of the debugfs files on shutdown?
> 
> In drivers/clk/clk.c, there is no tear-down of debugfs files paired
> with clk_debug_init(), same with wakeup_sources_debugfs_init() from
> drivers/base/power/wakeup.c. On the other hand, some subsystems
> perform it. What would you prefer?

In my quest for symmetry I prefer to see files you add to be removed at
the proper time. :)

thanks,

greg k-h
