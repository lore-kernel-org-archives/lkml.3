Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289Ab3DDSB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:01:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52240 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764235Ab3DDSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:01:23 -0400
Message-ID: <515DBFEF.8060607@wwwdotorg.org>
Date: Thu, 04 Apr 2013 12:01:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] ARM: tegra: update device trees for USB binding
 rework
References: <1364978502-22887-1-git-send-email-vbyravarasu@nvidia.com> <1364978502-22887-3-git-send-email-vbyravarasu@nvidia.com> <515C8024.30204@wwwdotorg.org> <D958900912E20642BCBC71664EFECE3E6E50BE48AE@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E50BE48AE@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 07:01 AM, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>> Sent: Thursday, April 04, 2013 12:47 AM
>> To: Venu Byravarasu
>> Cc: gregkh@linuxfoundation.org; balbi@ti.com;
>> stern@rowland.harvard.edu; linux-tegra@vger.kernel.org; linux-
>> usb@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH v2 2/7] ARM: tegra: update device trees for USB binding
>> rework
>>
>> On 04/03/2013 02:41 AM, Venu Byravarasu wrote:
>>> This patch updates all Tegra board files so that they contain all the
>>
>> The binding documentation says that the vbus-supply property is required
>> in all cases. However, many of the DT files still don't have that
>> property even after this patch. That's inconsistent.
> 
> Will edit the binding to have the vbus-supply only for otg cases. 

>>> diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
>>
>>> +	usb-phy@c5000000 {
>>> +		vbus-supply = <&vbus_reg>;
>>> +		dr_mode = "otg";
>>> +	};
>>
>> Where is the nvidia,vbus-gpio property? Since your code changes don't
>> actually implement use of the vbus-supply property yet, they will expect
>> the vbus-gpio property to exist in the PHY node.
> 
> As of now Vbus-gpio is being used by EHCI driver only.
> As anyways we wanted to use vbus-supply, will implement its
> support in PHY driver and remove vbus-gpio from EHCI node. 
> Hence did not add vbus-gpio to PHY DT nodes.

Ah right. I thought that this patch series moved the use of vbus-gpio
from the EHCI to the PHY driver, just like it moved the handling of
other properties such as dr_mode. I guess that's not actually true.

Just so we're clear, I'd expect the following then:

* Update binding to remove references to vbus-gpio from EHCI binding,
add references to vbus-supply to PHY binding.

* Update DT to add vbus-supply to PHY nodes, but don't remove vbus-gpio
from EHCI nodes.

* The code in this series doesn't actually change the vbus-* usage yet.

...

* Once this series is finalized, create another follow-on patch that
adds vbus-supply handling in to the PHY driver, and removes vbus-gpio
handling from the EHCI driver.

* Finally, remove vbus-gpio from the DT files.

I think we're in agreement on this now, and this series mostly already
does exactly that. I just wanted to spell it out explicitly to make sure.
