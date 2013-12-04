Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab3LDPHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:07:13 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48034 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932178Ab3LDPHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:07:11 -0500
Date: Wed, 4 Dec 2013 15:07:09 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Jon Masters <jonathan@jonmasters.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [RFC part3 PATCH 2/2] ARM64 / clocksource: Use
 arch_timer_acpi_init()
Message-ID: <20131204150709.GF29200@e106331-lin.cambridge.arm.com>
References: <1386088891-2917-1-git-send-email-hanjun.guo@linaro.org>
 <1386088891-2917-3-git-send-email-hanjun.guo@linaro.org>
 <20131203170815.GB16025@e106331-lin.cambridge.arm.com>
 <529F3BCA.1020908@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529F3BCA.1020908@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 02:27:22PM +0000, Hanjun Guo wrote:
> On 2013年12月04日 01:08, Mark Rutland wrote:
> > On Tue, Dec 03, 2013 at 04:41:31PM +0000, Hanjun Guo wrote:
> >> Use arch_timer_acpi_init() on ARM64 to initialise arch timer
> >> in ACPI way when DT is not available.
> >>
> >> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> >> ---
> >>   arch/arm64/kernel/time.c |    4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
> >> index 29c39d5..fb009da 100644
> >> --- a/arch/arm64/kernel/time.c
> >> +++ b/arch/arm64/kernel/time.c
> >> @@ -67,6 +67,10 @@ void __init time_init(void)
> >>   
> >>   	clocksource_of_init();
> >>   
> >> +	/* if can't be initialised from DT, try ACPI way */
> >> +	if (!arch_timer_get_rate())
> >> +		arch_timer_acpi_init();
> >> +
> > As mentioned on the previous patch, I think for the timebeing we should
> > rely on CNTFREQ.
> >
> > Additionally, if you need to do this we should have an analagous
> > mechanism to clocksource_of_init() that performs this initialisation for
> > ACPI, and here we can call a clocksource_*_init function that does the
> > right thing.
> >
> > There's no need for this file to know anything about ACPI.
> 
> Oh, Amit already have some patches to introduce clocksource_acpi_init()
> like clocksource_of_init() did, please refer to the link below.
> 
> http://marc.info/?l=linaro-acpi&m=138131929721943&w=2
> 
> is this the idea you mentioned in your comments?

Something along those lines is far better than hardcoding
arch_timer_acpi_init here.

Thanks,
Mark.
