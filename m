Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab3FQJcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:32:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36574 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756030Ab3FQJcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:32:50 -0400
Date: Mon, 17 Jun 2013 10:32:48 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stuart Menefy <stuart.menefy@st.com>, Mark Brown <broonie@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v2 09/11] ARM:stixxxx: Add stixxxx options to
 multi_v7_defconfig
Message-ID: <20130617093248.GB6809@e106331-lin.cambridge.arm.com>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com>
 <1370856477-7237-1-git-send-email-srinivas.kandagatla@st.com>
 <20130610104032.GA2513@e106331-lin.cambridge.arm.com>
 <51B5B15E.50901@st.com>
 <20130610131513.GB2513@e106331-lin.cambridge.arm.com>
 <51B98FDD.4010401@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B98FDD.4010401@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 10:24:45AM +0100, Srinivas KANDAGATLA wrote:
> On 10/06/13 14:15, Mark Rutland wrote:
> > CONFIG_EXPERIMENTAL's gone as of 3d374d09f1: "final removal of
> > CONFIG_EXPERIMENTAL", so that's fine to go. CONFIG_GPIO_PL061 and
> > CONFIG_MMC_WMT get selected elsewhere, so that's fine.
> > 
> 
> Am planning to send a patch to clean this up, so that any new platform
> addition to the multi_v7_defconfig will not under go this discussion again..
> 
> > It looks like the architected timer deselection is fallout of my own making,
> > the multi_v7_defconfig should now contain HAVE_ARM_ARCH_TIMER rather than
> > ARM_ARCH_TIMER.
> Why should it even contain HAVE_ARM_ARCH_TIMER/ARM_ARCH_TIMER?
> The only reason I see for de-selection is because none of the platforms
> in the multi_v7 defconfig selects it.
> 
> Looks like there is no platform in mulit_v7 config which requires this
> support. If there is one I think it should select it.
> 
> Am I correct?

You're right, I agree that the selection should be moved down into the
platforms requiring it. I'll put together patches to fix up those platforms.

Thanks,
Mark.
