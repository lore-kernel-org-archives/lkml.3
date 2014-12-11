Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbaLKMvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:51:49 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35477 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862AbaLKMvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:51:46 -0500
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CA0B0EB@AcuExch.aculab.com>
References: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
	<063D6719AE5E284EB5DD2968C1650D6D1CA0B0EB@AcuExch.aculab.com>
Date: Thu, 11 Dec 2014 18:21:45 +0530
Message-ID: <CAFp+6iEDvBDfg6FepOs48+CwoDhdEKAnF5C0MrHdBgPFSot5TQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] phy: samsung-usb2: Add support for Vbus regulator
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: David Laight <David.Laight@aculab.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "k.debski@samsung.com" <k.debski@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 5:52 PM, David Laight <David.Laight@aculab.com> wrote:
> From: Vivek Gautam
>> This has been on my to-do list for sometime.
>> Until now the host controller (specifically ehci-exynos) is responsible
>> for enabling VBUS supply. This opens up one more issue which is, when
>> only ohci-exynos is enabled and ehci-exynosis disabled then VBUS was
>> never enabled (since ohci did not have the code to enabled the VBUS supply).
>>
>> Rather it should be wise to move the VBUS related stuff to phy driver and
>> let phy take care of enabling it.
>>
>> This patch series adds that VBUS regulator to phy-samsung-usb2 driver,
>> adds necessary binding information as well as vbus-supply properties
>> to phy nodes on exynos5250 systems.
> ...
>
> Does this go anyway to allowing devices to be powered from a micro-usb
> connector while acting as a USB host (USB OTG).
> ie when you want VBUS disabled even though it would normally
> need to be enabled.

Sorry i didn't get your second line.

This change allows HOST and HSIC phys to enable VBUS for the devices
connected to it.
Although now i think there can be a flaw in this approach
when only in OTG mode, when DEVICE phy is being used, even then
the regulator will be turned on causing power unnecessary consumption.




-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
