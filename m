Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3CEG2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:28:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:64470 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab3CEG2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:28:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,785,1355126400"; 
   d="scan'208";a="208908974"
Date: Tue, 5 Mar 2013 14:27:17 +0800
From: Feng Tang <feng.tang@intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [RFC PATCH v2 0/4] Add support for S3 non-stop TSC support.
Message-ID: <20130305062717.GA5340@feng-snb>
References: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
 <20130305035302.GA5239@feng-snb>
 <20130305043203.GA26678@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305043203.GA26678@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 09:32:03PM -0700, Jason Gunthorpe wrote:
> On Tue, Mar 05, 2013 at 11:53:02AM +0800, Feng Tang wrote:

> > > You may want to also CC the maintainers of all the ARM subsystems that
> > > use read_persistent_clock and check with them to ensure this new
> > > interface will let them migrate their implementations as well.
> > 
> > Maybe I didn't get it well, my patches didn't change the
> > read_persistent_clock(), but inject a new way of counting suspended
> > time. It should have no functional changes to existing platforms.
> 
> Right, your patches are fine stand alone.
> 
> The ARM case of plat-omap/counter_32k.c would ideally be converted to
> use your new API though, that is what I ment about involving them.

I see now. Yes, the counter_32k could be converted to a clocksource
with SUSPEND_NONSTOP flag set, and no need for it to use the
read_persistent_clock any more.

> 
> I'm not sure about mach-tegra/timer.c though - it seems to be using a
> counter as well but somehow sharing registers with the RTC?

I just searched the 3.9-rc1 code, seems the file has been moved to
drivers/clocksource/tegra20_timer.c, and its persistent clock seems
to also be based on a RTC like device.

Thanks,
Feng

