Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3FJNPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:15:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47496 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038Ab3FJNPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:15:15 -0400
Date: Mon, 10 Jun 2013 14:15:13 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>, Mark Brown <broonie@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v2 09/11] ARM:stixxxx: Add stixxxx options to
 multi_v7_defconfig
Message-ID: <20130610131513.GB2513@e106331-lin.cambridge.arm.com>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com>
 <1370856477-7237-1-git-send-email-srinivas.kandagatla@st.com>
 <20130610104032.GA2513@e106331-lin.cambridge.arm.com>
 <51B5B15E.50901@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B5B15E.50901@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 11:58:38AM +0100, Srinivas KANDAGATLA wrote:
> Thanks for testing...
> On 10/06/13 11:40, Mark Rutland wrote:
> > On Mon, Jun 10, 2013 at 10:27:57AM +0100, Srinivas KANDAGATLA wrote:
> >> > This patch adds stih415 and stih416 support to multi_v7_defconfig.
> > This seems to drop a few options also:
> > 
> > CONFIG_ARM_ARCH_TIMER
> 
> Same as last comment 2:
> > CONFIG_ARM_ERRATA_754322
> ARM_ERRATA_754322 gets selected by the mach level Kconfig of stixxxx, so
> it disappears, Should the mach level Kconfig select that?
> 

I couldn't find the patch adding mach-stixxxx's Kconfig, though I seem to be
missing patch 6 of the series. As long as CONFIG_ARM_ERRATA_754322 appears in
the resulting .config, it should be fine.

> > CONFIG_EXPERIMENTAL
> > CONFIG_GPIO_PL061
> > CONFIG_MMC_WMT
> 
> Comment 2: Without any modifications to multi_v7_defconfig if I run
> savedefconfig CONFIG_ARM_ARCH_TIMER, CONFIG_EXPERIMENTAL,
> CONFIG_GPIO_PL061 and CONFIG_MMC_WMT disappears.
> Which suggests that these options seems to be selected by another
> kconfigs or mach level. And since then the multi_v7_defconfig was not
> run with savedefconfig.

CONFIG_EXPERIMENTAL's gone as of 3d374d09f1: "final removal of
CONFIG_EXPERIMENTAL", so that's fine to go. CONFIG_GPIO_PL061 and
CONFIG_MMC_WMT get selected elsewhere, so that's fine.

It looks like the architected timer deselection is fallout of my own making,
the multi_v7_defconfig should now contain HAVE_ARM_ARCH_TIMER rather than
ARM_ARCH_TIMER.

Thanks,
Mark.
