Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaLPUUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:20:06 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:52149 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLPUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:20:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Arun Ramamurthy <arun.ramamurthy@broadcom.com>, mark.rutland@arm.com,
        a.zummo@towertech.it, sbranden@broadcom.com, pawel.moll@arm.com,
        devicetree@vger.kernel.org, rjui@broadcom.com,
        ijc+devicetree@hellion.org.uk, Arun Ramamurthy <arunrama@broadcom.com>,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        galak@codeaurora.org, rtc-linux@googlegroups.com
Subject: Re: [PATCHv1] rtc: bcm-iproc: Add support for Broadcom iproc rtc
Date: Tue, 16 Dec 2014 21:19:05 +0100
Message-ID: <1418783023.hzNZBNCmFc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54909074.2070804@broadcom.com>
References: <1418757750-3628-1-git-send-email-arun.ramamurthy@broadcom.com> <7947905.aK8KkUx4sY@wuerfel> <54909074.2070804@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:B4mJKDCh6jf3d7/7T5Nl80gbfhw8C4JVuNNCrE/p7dvEIuPrQRW
 BpdHZMY7A/4Pg38uF36g7EkbU4GcpcNPHMdjkDMhc8XCWlDOMQosdAIb6sY/jpmRscblnUv
 el88mp79GbrpX/1g/HAHNJJ5igAj1Zo3gw7CYSOoV6ez0d5ttdOrPUTV1KBwW8JFcmQKIws
 FzzEDacVzX5LAm6kZzq6Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2014 12:05:08 Arun Ramamurthy wrote:
> On 14-12-16 11:42 AM, Arnd Bergmann wrote:
> > On Tuesday 16 December 2014 11:22:30 arun.ramamurthy@broadcom.com wrote:
> >> +       rtc: iproc_rtc@0x03026000 {
> >> +               compatible = "brcm,iproc-rtc";
> >> +               reg =   spru_bbl:               <0x03026000 0xC>,
> >> +                       crmu_pwr_good_status:   <0x0301C02C 0x14>,
> >> +                       crmu_bbl_auth:          <0x03024C74 0x8>;
> >> +               interrupts = spru_rtc_periodic: <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
> >> +                            spru_alarm:        <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>;
> >
> > The reg properties look really random, could it be that the registers
> > are really part of some other device that contains multiple functions?
> >
> This RTC block is on a battery backed logic island and is accessed 
> indirectly using the spru_bbl registers. The CRMU registers are required 
> to read the power status and write to some authentication registers. 
> Without writing to these authentication
> registers, we cannot access any of the spru_bbl registers. In conclusion
> I don't think the CRMU register accesses can be considered as another 
> device access. Do you agree Arnd?

It sounds like CRMU is some other unit aside from the RTC. Could this
be something like a generic system controller? I think it should
either have its own driver or use the syscon logic if that is what
this is.

> > Also, what do you use the labels for?
> >
> The labels are purely to improve readability of the device tree entry

Please remove them then, they don't help at all.

	Arnd
