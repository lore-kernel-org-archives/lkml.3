Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3FJLBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:01:19 -0400
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:39156 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab3FJLBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:01:17 -0400
Message-ID: <51B5B15E.50901@st.com>
Date: Mon, 10 Jun 2013 11:58:38 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
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
Subject: Re: [PATCH v2 09/11] ARM:stixxxx: Add stixxxx options to multi_v7_defconfig
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <1370856477-7237-1-git-send-email-srinivas.kandagatla@st.com> <20130610104032.GA2513@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130610104032.GA2513@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for testing...
On 10/06/13 11:40, Mark Rutland wrote:
> On Mon, Jun 10, 2013 at 10:27:57AM +0100, Srinivas KANDAGATLA wrote:
>> > This patch adds stih415 and stih416 support to multi_v7_defconfig.
> This seems to drop a few options also:
> 
> CONFIG_ARM_ARCH_TIMER

Same as last comment 2:
> CONFIG_ARM_ERRATA_754322
ARM_ERRATA_754322 gets selected by the mach level Kconfig of stixxxx, so
it disappears, Should the mach level Kconfig select that?

> CONFIG_EXPERIMENTAL
> CONFIG_GPIO_PL061
> CONFIG_MMC_WMT

Comment 2: Without any modifications to multi_v7_defconfig if I run
savedefconfig CONFIG_ARM_ARCH_TIMER, CONFIG_EXPERIMENTAL,
CONFIG_GPIO_PL061 and CONFIG_MMC_WMT disappears.
Which suggests that these options seems to be selected by another
kconfigs or mach level. And since then the multi_v7_defconfig was not
run with savedefconfig.


Thanks,
srini
> 
> I just applied this to v3.10-rc5, and ran `make ARCH=arm multi_v7_defconfig`.
> It seems MMC_WMT and GPIO_PL061 get selected elsewhere, but ARM_ARCH_TIMER and
> ARM_ERRATA_754322 are left unselected.
> 
> Thanks,
> Mark.
> 

