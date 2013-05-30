Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965766Ab3E3Rjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:39:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2672 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609Ab3E3Rjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:39:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 30 May 2013 10:39:29 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'Stephen Warren'" <swarren@wwwdotorg.org>
CC: "'thierry.reding@avionic-design.de'" 
	<thierry.reding@avionic-design.de>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'bhelgaas@google.com'" <bhelgaas@google.com>,
        "'olof@lixom.net'" <olof@lixom.net>,
        "'mturquette@linaro.org'" <mturquette@linaro.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>
Date: Thu, 30 May 2013 23:07:57 +0530
Subject: RE: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
Thread-Topic: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
Thread-Index: Ac5cgjAJRwIVsZEvQRC/CXMRoq5IHwA2Z3HA
Message-ID: <C79B248886DD134989C8FF6B096A91AB91B616BEA6@BGMAIL01.nvidia.com>
References: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com>
 <1368010660-31465-4-git-send-email-jagarwal@nvidia.com>
 <518A8596.7070702@wwwdotorg.org>
 <C79B248886DD134989C8FF6B096A91AB91B4886B5D@BGMAIL01.nvidia.com>
 <C79B248886DD134989C8FF6B096A91AB91B4886B6C@BGMAIL01.nvidia.com>
 <C79B248886DD134989C8FF6B096A91AB91B616BE9B@BGMAIL01.nvidia.com>
 <51A62042.7070304@wwwdotorg.org>
In-Reply-To: <51A62042.7070304@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 05/29/2013 04:10 AM, Jay Agarwal wrote:
> >>>> So, if I apply this series, I do see the PCIe bridge and Ethernet
> >>>> device get enumerated, but I don't see the USB3 controller get
> >>>> enumerated. I believe that is a PCIe device behind the same bridge
> >>>> on the
> >>> same Tegra PCIe port.
> >>>> Shouldn't this device show up?
> >>> I have also reproduced this problem. I see somehow no non-
> >>> prefetchable memory is assigned to any of pcie devices.
> >>> Probably that is the reason for USB3 (pci 0000:04:00.0) not getting
> >>> enumerated since it uses only non-prefetchable memory.
> >>
> >> 1. Bus4(on which usb3 device resides) always return 0xffffffff from
> >> it's config space. which means device is not present?
> >> 2. That's why it is not assigned any resources and hence no usb3
> >> probe happens.
> >> 3. But same bus does return valid info like vendor/device id etc from
> >> it's config space in downstream kernel and hence usb3 probe does
> happen.
> >>
> >> Thierry, Stephen,
> >> 4. Any idea why bus4 should return 0xffffffff values in upstream kernel?
> >> Anything missing?
> >> 5. Also, how config space of all pcie devices are mapped? I mean if I
> >> change the config space offset in dts file, then also I find correct
> >> vendor/device id etc for bus0/device0/fun0.
> >>     So how this mapping happens that even after changing the config
> >> space offset in PCIe address space, it always finds correct vendor/device
> id.
> >
> >  Any idea on this?
> 
> I did already reply the same day you sent the original email. My response
> was:
> 
> Is there some reset/enable GPIO or regulator that needs to be programmed
> to enable the PCIe USB3 controller? Take a look at the schematic. If you can
> make it work by tweaking those GPIOs/... manually, then we can ignore this
> issue and fix it up later, since it's not directly related to the PCIe controller
> driver patches. It's more important to get the Ethernet working than USB, I
> think.
> 
> To be honest though, I would expect you to be asking around inside NVIDIA
> to determine the answer here. As the PCIe SW expert, I'd expect you to
> drive this process. Try asking the Cardhu board and PCIe HW experts within
> NVIDIA.
> 
> Did you make any progress on the issues with the Ethernet device?

Stephen, 
I have taken care of all your comments, but Ethernet device is not working for me neither on cardhu nor harmony. 
Could be related to my process or board, Currently debugging this.
Parallely, should I push my patches for review so that it is clear from other aspects?
 
