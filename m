Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbaKAPnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 11:43:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaKAPnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 11:43:46 -0400
Message-ID: <5454FFAC.2040500@suse.de>
Date: Sat, 01 Nov 2014 16:43:40 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: Bjorn Andersson <bjorn@kryo.se>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v2 3/3] ARM: dts: qcom: Add SDHC nodes for APQ8084 platform
References: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>	<1409672443-4289-4-git-send-email-gdjakov@mm-sol.com> <CAJAp7OhV82HyDQSRW4F2z6UD6WZzuopBoUZMeT2pYBdGq-Dqcg@mail.gmail.com> <543D4C87.9050703@mm-sol.com>
In-Reply-To: <543D4C87.9050703@mm-sol.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Georgi,

Am 14.10.2014 um 18:17 schrieb Georgi Djakov:
> On 10/10/2014 08:14 PM, Bjorn Andersson wrote:
>> On Tue, Sep 2, 2014 at 8:40 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
>>> Enable support for the two SD host controllers on the APQ8084 platform
>>> by adding the required nodes to the DT files.
>>> On the IFC6540 board, the first controller is connected to the onboard
>>> eMMC and the second is connected to a micro-SD card slot.
>>>
>>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
[...]
>>> ---
>>>  arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |   11 +++++++++++
>>>  arch/arm/boot/dts/qcom-apq8084.dtsi        |   23 +++++++++++++++++++++++
>>>  2 files changed, 34 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>>> index e41cb8a..c9ff108 100644
>>> --- a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>>> +++ b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>> [..]
>>> +               sdhci@f98a4900 {
>>> +                       cd-gpios = <&tlmm 122 GPIO_ACTIVE_LOW>;
>>> +                       bus-width = <4>;
>>
>> ...why do you add this node and leave it disabled in the dts?
>>
> 
> Hi Bjorn,
> Currently only the eMMC is functional on this board, so now we
> have just the board specific configuration under this node.
> More patches are forthcoming.

Any update on this? This still seems to be the latest IFC6540 commit:

https://git.linaro.org/landing-teams/working/qualcomm/kernel.git/commit/66c04e30f4a6e6ed998a6c154a6c45b3cd5b3fde

Following the instructions in https://wiki.linaro.org/Boards/IFC6540
I've tried to pass a full rootfs as ramdisk parameter (fastboot boot -c
"console=ttyMSM0,115200,n8 rw rootwait" -b 0x0 zImage-ifc6540
initrd.cpio.gz), but I then get:

[258660] fastboot: download:12738800
[268150] fastboot: boot
[268150] kernel/ramdisk addresses overlap with aboot addresses.

Booting without ramdisk specified works, but for lack of SD, USB and
network support I then have no root.

So, do you have any new insights on why 'status = "okay";' doesn't work
for the above sdhci node? Or do you have a working config you can share
for creating a non-overlapping abootimg?

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
