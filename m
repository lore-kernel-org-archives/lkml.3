Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaLPUFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:05:37 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:8357 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaLPUFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:05:36 -0500
X-IronPort-AV: E=Sophos;i="5.07,588,1413270000"; 
   d="scan'208";a="53376333"
Message-ID: <54909074.2070804@broadcom.com>
Date: Tue, 16 Dec 2014 12:05:08 -0800
From: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <sbranden@broadcom.com>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <rjui@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>
Subject: Re: [PATCHv1] rtc: bcm-iproc: Add support for Broadcom iproc rtc
References: <1418757750-3628-1-git-send-email-arun.ramamurthy@broadcom.com> <7947905.aK8KkUx4sY@wuerfel>
In-Reply-To: <7947905.aK8KkUx4sY@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14-12-16 11:42 AM, Arnd Bergmann wrote:
> On Tuesday 16 December 2014 11:22:30 arun.ramamurthy@broadcom.com wrote:
>> +       rtc: iproc_rtc@0x03026000 {
>> +               compatible = "brcm,iproc-rtc";
>> +               reg =   spru_bbl:               <0x03026000 0xC>,
>> +                       crmu_pwr_good_status:   <0x0301C02C 0x14>,
>> +                       crmu_bbl_auth:          <0x03024C74 0x8>;
>> +               interrupts = spru_rtc_periodic: <GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
>> +                            spru_alarm:        <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>;
>
> The reg properties look really random, could it be that the registers
> are really part of some other device that contains multiple functions?
>
This RTC block is on a battery backed logic island and is accessed 
indirectly using the spru_bbl registers. The CRMU registers are required 
to read the power status and write to some authentication registers. 
Without writing to these authentication
registers, we cannot access any of the spru_bbl registers. In conclusion
I don't think the CRMU register accesses can be considered as another 
device access. Do you agree Arnd?

> Also, what do you use the labels for?
>
The labels are purely to improve readability of the device tree entry
> 	Arnd
>
