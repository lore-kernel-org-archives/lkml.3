Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaKBIIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 03:08:42 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58204 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaKBIIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 03:08:38 -0500
Message-ID: <5455E682.1040306@linaro.org>
Date: Sun, 02 Nov 2014 08:08:34 +0000
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Georgi Djakov <gdjakov@mm-sol.com>
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
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v2 3/3] ARM: dts: qcom: Add SDHC nodes for APQ8084 platform
References: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>	<1409672443-4289-4-git-send-email-gdjakov@mm-sol.com> <CAJAp7OhV82HyDQSRW4F2z6UD6WZzuopBoUZMeT2pYBdGq-Dqcg@mail.gmail.com> <543D4C87.9050703@mm-sol.com> <5454FFAC.2040500@suse.de>
In-Reply-To: <5454FFAC.2040500@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On 01/11/14 15:43, Andreas Färber wrote:
> Hi Georgi,
>
> Am 14.10.2014 um 18:17 schrieb Georgi Djakov:
>> On 10/10/2014 08:14 PM, Bjorn Andersson wrote:
>>> On Tue, Sep 2, 2014 at 8:40 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
>>>> Enable support for the two SD host controllers on the APQ8084 platform
>>>> by adding the required nodes to the DT files.
>>>> On the IFC6540 board, the first controller is connected to the onboard
>>>> eMMC and the second is connected to a micro-SD card slot.
>>>>
>>>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> [...]
>>>> ---
>>>>   arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |   11 +++++++++++
>>>>   arch/arm/boot/dts/qcom-apq8084.dtsi        |   23 +++++++++++++++++++++++
>>>>   2 files changed, 34 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>>>> index e41cb8a..c9ff108 100644
>>>> --- a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>>>> +++ b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>>> [..]
>>>> +               sdhci@f98a4900 {
>>>> +                       cd-gpios = <&tlmm 122 GPIO_ACTIVE_LOW>;
>>>> +                       bus-width = <4>;
>>>
>>> ...why do you add this node and leave it disabled in the dts?
>>>
>>
>> Hi Bjorn,
>> Currently only the eMMC is functional on this board, so now we
>> have just the board specific configuration under this node.
>> More patches are forthcoming.
>
> Any update on this? This still seems to be the latest IFC6540 commit:
>
> https://git.linaro.org/landing-teams/working/qualcomm/kernel.git/commit/66c04e30f4a6e6ed998a6c154a6c45b3cd5b3fde
>
> Following the instructions in https://wiki.linaro.org/Boards/IFC6540

I did update the wiki with more instructions to flash rootfs on to eMMC.

> I've tried to pass a full rootfs as ramdisk parameter (fastboot boot -c
> "console=ttyMSM0,115200,n8 rw rootwait" -b 0x0 zImage-ifc6540
> initrd.cpio.gz), but I then get:
There is a typo here, I fixed it as well.
#sudo fastboot boot -c "console=ttyMSM0,115200,n8 root=/dev/mmcblk0p25 
rootwait rw" -b 0x80200000 zImage-dtb

Could you give this a try?

>
> [258660] fastboot: download:12738800
> [268150] fastboot: boot
> [268150] kernel/ramdisk addresses overlap with aboot addresses.
>
> Booting without ramdisk specified works, but for lack of SD, USB and
> network support I then have no root.
>
Now you can flash the rootfs into the eMMC partition.
> So, do you have any new insights on why 'status = "okay";' doesn't work
> for the above sdhci node? Or do you have a working config you can share
> for creating a non-overlapping abootimg?

thanks,
sirni
>
> Regards,
> Andreas
>
