Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3FJOCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:02:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52753 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab3FJOB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:01:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, srinivas.kandagatla@st.com
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>, Mark Brown <broonie@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v2 04/11] mfd:stixxxx-syscfg: Add ST System Configuration support.
Date: Mon, 10 Jun 2013 16:02:04 +0200
Message-ID: <2757224.FBxg98dX57@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <51B5DA26.6070707@st.com>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <CACRpkdaW2ALTWCB7Rd8m=aAGQwh3T_dJVncxJn_eXer4X3J6_g@mail.gmail.com> <51B5DA26.6070707@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BGPTv2/0M/s/suPUkA1SYx12jsUJxUD/vYnx7HZ0eAk
 vAC8VrL8JPKRFMpMlO4tsVWhJ4H9DOaEfm2CVoDCI51PocF/4a
 oLSUTy9ytV62gDWofAz+06WetySy1Rg7pl9zXeSCDjIbggLkfl
 3j9g1Z7jr5y0Cgw02cTgGB7JLhnBRip5DLVpqsS9nEbPP1Xt6p
 JZcCKZBg5gNvtOMAOq3eNXrjplNR85WhJZr7/R+j6L8u3hrOcK
 HuFXH63bYmjOEafml04vwVbEq6NMHUnLXeBAvKfWTljRCXnmNN
 B7UjO5Nwja3L62MsHijzg1vI78wf2NvK9aMrhZtYH5nZudTv3Y
 ynuWZiyr45i3otRacr+Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 June 2013 14:52:38 Srinivas KANDAGATLA wrote:
> On 10/06/13 14:16, Linus Walleij wrote:
> > On Mon, Jun 10, 2013 at 11:22 AM, Srinivas KANDAGATLA
> > <srinivas.kandagatla@st.com> wrote:
> > 
> >> This mfd driver provides higher level inialization routines for various
> >> IPs like Ethernet, USB, PCIE, SATA and so on. Also it provides way to
> >> get to syscfg registers via standard regmap api which is usefull for
> >> drivers like pinctrl.
> >>
> >> This patch adds support to ST System Configuration registers, which can
> >> be configured by the drivers.
> >>
> >> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> >> CC: Stuart Menefy <stuart.menefy@st.com>
> >> CC: Stephen Gallimore <stephen.gallimore@st.com>
> >> CC: Linus Walleij <linus.walleij@linaro.org>
> >> CC: Mark Brown <broonie@kernel.org>
> > 
> > What is this driver doing that drivers/mfd/syscon.c is not already
> > doing?
>
> As of now, the driver is very much similar to syscon + some additional
> functionality, but we are planning to use this file to add higher level
> functions to configure different IPs like ethernet, usb, power, reset
> and so on which are very much specific to ST System Configuration Registers.

I was expecting that you'd actually interface with the syscon code and
build on top, rather than copy it.

There are multiple ways of doing that, e.g. you could export a function
from syscon.c that you call to register the device node and then import
the regmap from syscon into your high-level driver again.

	Arnd
