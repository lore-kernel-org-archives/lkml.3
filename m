Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaK1QcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:32:21 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:57966 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaK1QcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:32:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v2 RESEND 1/2] ARM: vexpress: Remove non-DT code
Date: Fri, 28 Nov 2014 17:31:45 +0100
Message-ID: <3935390.Q4yT7WfqCv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417189984.4371.12.camel@arm.com>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com> <20141128153026.GU3836@n2100.arm.linux.org.uk> <1417189984.4371.12.camel@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wVXSuSAHaiC/V0lQl05T1Uqsjs2nDYUFHyYCq5B9dRY
 6v/TV6Osem8nVKT54COBdSrg9jC/CVljLszfpGyp1W/mc8D3Ju
 0fr5XxllajIGQzYmuxYvt4ZGO5jSGUepeVz/uyt/UWKVxTUBTC
 1/m3I6UlpAOtmPFNymUs1VWWwmcAAcjdQY8b+ZIK70v2K34fRi
 29gPnDaZgFSECShlaGPjn7sbE069m0Kb8EL3qhDhN8BI4AHoBU
 yoZ9dShfNz32qN4j+kgMiI5wQfTSZOoNSWI/C4EGAktO2b1+zR
 VR1xdhYczsf9Q9whdcMPDNw1/G+U7sorx/6yccSrXxfqgUXYUi
 YPU4+E7MNnRALMzKy+xI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 15:53:04 Pawel Moll wrote:
> vmmc-supply is a defined as:
> 
>                                 vmmc-supply = <&v2m_fixed_3v3>;
> 
> which is:
> 
>                 v2m_fixed_3v3: fixedregulator@0 {
>                         compatible = "regulator-fixed";
> 
> and arch/arm/mach-vexpress/Kconfig says:
> 
> menuconfig ARCH_VEXPRESS
> [...]
>         select REGULATOR_FIXED_VOLTAGE if REGULATOR
> 
> but it doesn't select REGULATOR in result of this discussion:
> 
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/223426/focus=223427
> 
> To summarize, I believe that setting CONFIG_REGULATOR=y (as in
> vexpress_defconfig) should solve your issue.

Well, there is clearly a bug somewhere. As you say, the mmc driver
now uses the regulator API to check the voltage instead of using
platform_data. But there is no dependency on having the regulator
support around, so it can't.

I would suggest applying your patch from
http://thread.gmane.org/gmane.linux.ports.arm.kernel/223426/focus=224128
after all, or just hardcoding regulator support like a lot of other
platforms do.

	Arnd
