Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab3IPPIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:08:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:11350 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab3IPPIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:08:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,915,1371106800"; 
   d="scan'208";a="361184735"
Date: Mon, 16 Sep 2013 18:13:33 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Graeme Gregory <graeme.gregory@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
Message-ID: <20130916151333.GQ7393@intel.com>
References: <87bo3whjz4.fsf@linaro.org>
 <20130913145022.GC7393@intel.com>
 <20130913173149.GE7393@intel.com>
 <87ioy4e8bw.fsf@linaro.org>
 <20130915064139.GJ7393@intel.com>
 <20130915124744.GW29403@sirena.org.uk>
 <20130915132823.GL7393@intel.com>
 <20130916101249.GX29403@sirena.org.uk>
 <20130916143811.GP7393@intel.com>
 <20130916144616.GM1823@xora-yoga.xora.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916144616.GM1823@xora-yoga.xora.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 03:46:16PM +0100, Graeme Gregory wrote:
> On Mon, Sep 16, 2013 at 05:38:12PM +0300, Mika Westerberg wrote:
> > On Mon, Sep 16, 2013 at 11:12:49AM +0100, Mark Brown wrote:
> > > That's definitely an ACPI specific (probably x86 specific ACPI?)
> > > requirement not a generic one, on some systems it would increase power
> > > consumption since the controller will need to sit on while the device is
> > > functioning autonomously.
> > 
> > Yes, the ACPI 5.0 spec says that the device cannot be in higher D-state
> > than its parent. This is not x86 specific, though I'm not sure if this is
> > implemented elsewhere.
> > 
> I do not think this stops the OS fine controlling the power of the device
> though. It is only a mechanism to make sure the tree of D states is vaguely
> sane from the ACPI point of view. What happens in each D state is never
> actually defined in the ACPI spec.

I think there's a pretty good definition of the D-states in chapter 2.3 of
the ACPI 5.0 spec.

In our case the problem is that the I2C controller is in D3Cold (off) and
we try to move the I2C client device to D0 (on) it violates the ACPI spec.

Anyway we are looking if we can somehow make this work in such way that it
doesn't prevent non-ACPI devices from functioning as they expect now.
