Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3IKLAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:00:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:58821 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab3IKLAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:00:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,883,1371106800"; 
   d="scan'208";a="376548464"
Date: Wed, 11 Sep 2013 14:05:43 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C
 client devices
Message-ID: <20130911110543.GA7393@intel.com>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com>
 <3397524.g9aUWuArnm@vostro.rjw.lan>
 <20130910213522.GG29403@sirena.org.uk>
 <2029393.u6DaKBPszu@vostro.rjw.lan>
 <522FC0DC.9030708@intel.com>
 <20130911095552.GI29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911095552.GI29403@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:55:52AM +0100, Mark Brown wrote:
> On Wed, Sep 11, 2013 at 09:01:16AM +0800, Aaron Lu wrote:
> 
> > Looks like, it all boils down to how many I2C devices should be allowed
> > for runtime PM by default and how many I2C devices should be forbidden.
> > , and then we allow/forbid runtime PM for the majority case in I2C core
> > while individual driver can still forbid/allow it in their own code.
> 
> > So if the majority case is runtime PM should be allowed by default, I'm
> > also OK to not forbid runtime PM for I2C client device in I2C core. My
> > original intention to forbid runtime PM by default is to make sure no
> > adverse effect would occur to some I2C devices that used to work well
> > before runtime PM.
> 
> The really big problem here is that there are I2C devices currently
> using runtime PM quite happily and forbidding it by default will break
> them.
> 
> In general though requiring userspace to manually activate power saving
> features isn't going to make people happy.

Yeah, we are going change that in the next revision (default to RPM
unblocked).

I'll also look into converting the existing I2C client drivers to use this
method. One question, though, is it better to have the conversion in the
same patch that introduces the I2C core runtime PM change or as a separate
patch?
