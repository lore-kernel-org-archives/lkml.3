Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3FYOAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:00:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:56049 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3FYOA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:00:27 -0400
Date: Tue, 25 Jun 2013 16:00:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
cc: John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6] clocksource:arm_global_timer: Add ARM global timer
 support.
In-Reply-To: <51C99E33.4070009@st.com>
Message-ID: <alpine.DEB.2.02.1306251559160.4013@ionos.tec.linutronix.de>
References: <1372152678-29530-1-git-send-email-srinivas.kandagatla@st.com> <alpine.DEB.2.02.1306251459160.4013@ionos.tec.linutronix.de> <51C99E33.4070009@st.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013, Srinivas KANDAGATLA wrote:
> On 25/06/13 14:17, Thomas Gleixner wrote:
> > On Tue, 25 Jun 2013, Srinivas KANDAGATLA wrote:
> >> +static void gt_compare_set(unsigned long delta, int periodic)
> >> +{
> >> +	u64 counter = gt_counter_read();
> >> +	unsigned long ctrl = readl(gt_base + GT_CONTROL);
> > 
> > Why are you reading the control register back over and over? All you
> > need to preserve is the GT_CONTROL_TIMER_ENABLE bit. So you can spare
> > that read out and just do
> > 
> > 	ctrl = GT_CONTROL_TIMER_ENABLE;
> > 	writel(ctrl, gt_base + GT_CONTROL);
> 
> Logically you are right we could do as you suggested, However its not
> implicit that which bits are going to be cleared. Its more to do with
> readability of the code.
> If you still insist I can change it.

I'm not insisting. I just pointed out, that you can save cycles in a
hotpath. :)

Thanks,

	tglx
