Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3IWHTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:19:09 -0400
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:58285 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3IWHTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:19:08 -0400
Message-ID: <1379920736.30708.26.camel@dagon.hellion.org.uk>
Subject: Re: [PATCH 1/3] Add smp support for Allwinner A20(sunxi 7i).
From: Ian Campbell <ijc@hellion.org.uk>
To: cinifr <cinifr@gmail.com>
Cc: "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Date: Mon, 23 Sep 2013 08:18:56 +0100
In-Reply-To: <CAK3cCBzMXdeeSPC-OpWcHAuef=ocpy5n0=Fc2yBECPnU=2OTXw@mail.gmail.com>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
	 <1379852488-32147-2-git-send-email-cinifr@gmail.com>
	 <1379861045.30708.22.camel@dagon.hellion.org.uk>
	 <CAK3cCBzMXdeeSPC-OpWcHAuef=ocpy5n0=Fc2yBECPnU=2OTXw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 23:31 +0800, cinifr wrote:
> 
> 
> On Sunday, 22 September 2013, Ian Campbell <ijc@hellion.org.uk> wrote:
> > On Sun, 2013-09-22 at 20:21 +0800, Fan Rong wrote:
> >
> >> +     /* Set boot addr */
> >> +     paddr = virt_to_phys(sun7i_secondary_startup);
> >> +     writel(paddr, sunxi7i_cc_base + SUN7I_CPUCFG_BOOTADDR);
> >
> > This means that the secondary cores will miss out on any setup which
> the
> > bootloader might have done for the primary CPU, e.g. switching to NS
> HYP
> > mode, setting the CNTFRQ etc.
> Yes, I think that is what bootloader should do.

In which case this kernel patch needs instead to speak the bootloader
wakeup protocol instead of speaking to the h/w directly like you've done
here, right?

Or is it possible for the bootloader to set these things up and then put
the CPU back to sleep such that it both retains any settings and is
wakable by this patch? This code contains core resets and power control,
which makes me suspect not.

> > Wouldn't it be better to do all this stuff in the bootloader and
> either
> > implement PSCI or have the bootloader do the traditional holding pen
> and
> > mbox address thing?
> >
> I have modified uboot to set cntfrq and cntvoff in all smp cpus,and it
> works well. I guess kernel should believe all cpu should be all same
> when kernel boot. Bootloader should do it to ensure that.

Yes, I think all CPUs must be in the same state at boot.

But if you've done all that then what is this patch for?

Do you have links to your u-boot patches?

Ian.

