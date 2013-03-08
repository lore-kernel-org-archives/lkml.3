Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3CHGLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:11:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64972 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3CHGLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:11:50 -0500
Date: Fri, 8 Mar 2013 07:11:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: rjw@sisk.pl, Steve.Bannister@arm.com, linux@arm.linux.org.uk,
        linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        devicetree-discuss@lists.ozlabs.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        robin.randhawa@arm.com, linux-arm-kernel@lists.infradead.org,
        mark.hambleton@broadcom.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH V2] cpufreq: ARM big LITTLE: Add generic cpufreq driver
 and its DT glue
In-Reply-To: <CAKohpo=-_uzTi6QR4MnXPd5yAZFTcw-3ZZL-TAVY+drV-bDjNw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1303080706310.24111@axis700.grange>
References: <6cba8f153cfd4b0d3075a34a6dfe287bdec2eb06.1362676407.git.viresh.kumar@linaro.org>
 <Pine.LNX.4.64.1303072248560.20470@axis700.grange>
 <CAKohpo=-_uzTi6QR4MnXPd5yAZFTcw-3ZZL-TAVY+drV-bDjNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:25tq87TD65CB3VJhSGaJaZ0MB1Pgd9RSE0d8/1g6tU7
 Oo+WOmLEk3uvq5xss1CdtGo1kHRUUH58R02AavRpdJ4zdJmPrL
 ZBJgQrfsRrRm/OiSGZolFWgQwmbZ6D7It/XVBU+yo0bCVE+7Xk
 b8/hvdyOJA1I9M8qlslfON/n7u+V8D5Pt1nPu4mvuMQFT2AI9g
 VVlG7F2XoLNaoEX/EkspfnmRIURW3FwSYpfsb1ET1aCLH2+cC/
 g1tcYQNiUfAe8SVSPZNbmEI4DBdFJV98QDuWN3YMlElBHRnM2M
 SMdLzKOlxlPJPwtQNgFGUu+Y27AZKeVsHhk/pi6Y/AEMM2Pg67
 XcajCqVAFYK/pGXfH4Z2tRUossouY7ocTflDv2LS6UcS8RupR/
 SKSKAtRxAkXgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh

On Fri, 8 Mar 2013, Viresh Kumar wrote:

> On 8 March 2013 05:56, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > I like generic drivers :)
> 
> Me too :)
> 
> > cpufreq-cpu0 is yet another such generic
> > (cpufreq) driver. Now, comparing the functionality of the two:
> 
> Great!!
> 
> > we see, that this driver "only" switches CPU clock frequencies. Whereas
> > the cpufreq-cpu0 driver also manipulates a regulator (if available)
> > directly. I understand, power-saving is also an important consideration
> > for big.LITTLE systems. So, I presume, you plan to implement voltage
> > switching in cpufreq notifiers?
> 
> So the platform on which we are currently testing these is ARM TC2 Soc
> and this switching is done by the firmware instead. And so didn't went
> for regulator hookups initially.. Obviously in future regulator hookups would
> find some space in this driver but not required for now.
> 
> > Now, my question is: is this (notifier)
> > actually the preferred method and the cpufreq-cpu0 driver is doing it
> > "wrongly?"
> 
> What notifiers are you talking about? I believe using the regulator framework
> is the right way of doing this. And that would be part of this code later on.

Also in your driver you're doing

		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
		...
		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);

So, theoretically you could install such notifiers to adjust CPU voltages 
(using regulators too). But adding regulator calls directly to the driver 
would make it consistent with cpufreq-cpu0.c, so, if this doesn't violate 
any concepts, I think, it would be good to add those when suitable systems 
appear.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
