Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaJGHlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:41:49 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59378 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJGHlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:41:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sonny Rao <sonnyrao@chromium.org>, Mark Rutland <Mark.Rutland@arm.com>,
        devicetree@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, Doug Anderson <dianders@chromium.org>,
        galak@codeaurora.org, Sudeep Holla <Sudeep.Holla@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3] clocksource: arch_timer: Allow the device tree to specify uninitialized CNTVOFF
Date: Tue, 07 Oct 2014 09:40:57 +0200
Message-ID: <2943095.1HCacZ7zIg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412663852-32681-1-git-send-email-sonnyrao@chromium.org>
References: <1412663852-32681-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4t6c2+4s6ors2NgZ1rrjFQ3IYMa4ZoqySrtA3xk5yQz
 q7Ig8wZYOu6Lik7z+hlJE83RnFd6KgvbCE4yfWIQ+WuFpVSLwi
 0qKp3BkRCN2Wu7lKc+N2EgNHyfLRc/AQue8U1+PR+hj2uI2SHG
 NGraFXQgmq/xay1c9QIRxRSkREHDOu8PmDbwp2hgYPFsUwOEFN
 AO+Lz/4QrmaHqmZySe7ni0X6s4qCAhtko0gbj8sqjvDHGvBBIS
 PnelJOtk11oj4r2OiJ18f08nzRoJn+X2FLRe9IeGIphG8VOfyi
 i5cf/R8mGiUOSiR0SzZJ3Yqr1Lq59ApLWU4PI6aML7j6rwE17n
 tTqEsyVlY39sp21gx/bI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 October 2014 23:37:32 Sonny Rao wrote:
> 
> +#ifdef CONFIG_ARM
> +       /*
> +        * If we cannot rely on firmware initializing the CNTVOFF then
> +        * we should use the physical timers instead.
> +        */
> +       if (of_property_read_bool(np, "arm,cntvoff-not-fw-configured"))
> +               arch_timer_use_virtual = false;
> +#endif
> +
> 

Sorry for the nitpicking, but can this please use

	if (IS_ENABLED(CONFIG_ARM))

to avoid the ugly #ifdef?

	Arnd
