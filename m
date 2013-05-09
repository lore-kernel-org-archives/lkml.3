Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3EIOve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:51:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3EIOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:51:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: srinivas.kandagatla@st.com
Subject: Re: [RFC 2/8] ARM:global_timer: Add ARM global timer support.
Date: Thu, 9 May 2013 16:51:13 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Dave Martin <dave.martin@linaro.org>, linux-doc@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, will.deacon@arm.com,
        Grant Likely <grant.likely@secretlab.ca>, Jiri Slaby <jslaby@suse.cz>,
        linux@arm.linux.org.uk, Samuel Ortiz <sameo@linux.intel.com>,
        Nicolas Pitre <nico@linaro.org>, linux-serial@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Olof Johansson <olof@lixom.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <201305081638.23100.arnd@arndb.de> <518BADBF.4070303@st.com>
In-Reply-To: <518BADBF.4070303@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305091651.13896.arnd@arndb.de>
X-Provags-ID: V02:K0:bvirnyTnn8G15vm2FQBkDi5Y2nixSYf3YBxMOU33bhn
 Z/toSORJSl77drgTrJlpLE0M+WAw6JxrALx+EQhinTpRKd0JQW
 MX8nwyiBy/RTkgR6Jkxn1FXy9uwaX8Yp41Ikwt+CfeJeFQCaqD
 KFCXtd94QaX+G+5NA6JbwqGEoMKVvG2dEmdQWHuP0dU4+an6WU
 cEVJZgv8jL/CDGhHq2h/+QB2sssbzRatBbDTicNCwqAQm24bx6
 Wc/jgXYF99/LQU+x5M+zcXYGFzMJYSvXRGSwYF6T+EvTcwITGt
 eeaDq5JVgt5Q6NTkwBK5Tq3Cr+bfO5+z69u5ZiR/D/DOniY8/I
 RKryE/wSBJNBHa+LBGR8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 May 2013, Srinivas KANDAGATLA wrote:
> >> diff --git a/arch/arm/include/asm/global_timer.h b/arch/arm/include/asm/global_timer.h
> >> new file mode 100644
> >> index 0000000..46f9188
> >> --- /dev/null
> >> +++ b/arch/arm/include/asm/global_timer.h
> >> @@ -0,0 +1,12 @@
> >> +int __init global_timer_init(void __iomem *base, unsigned int timer_irq);
> > 
> > I don't see a need to call this from platform code for non-DT platforms, it
> > can easily be used with CLOCKSOURCE_OF_DECLARE() all the time I think.
> 
> sorry Am confused here.
> How would this work for non-DT?

It won't.

> Looking at the code in clocksource_of_init it just goes through the
> of_device_id table, which is not used in case of non-DT.

All new platforms are DT-only, and none of the old platforms use this
driver, so it does not matter.

	Arnd
