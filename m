Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab3CTGAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 02:00:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19233 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3CTGAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 02:00:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Mar 2013 23:00:06 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Wed, 20 Mar 2013 11:29:59 +0530
Subject: RE: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as
 platform driver
Thread-Topic: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as
 platform driver
Thread-Index: Ac4k20FsSu4SASIBRPmi9O9pJEYdOAAUaA6Q
Message-ID: <D958900912E20642BCBC71664EFECE3E6E5092FED0@BGMAIL02.nvidia.com>
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
 <5148C1DC.1020903@wwwdotorg.org>
In-Reply-To: <5148C1DC.1020903@wwwdotorg.org>
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

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Wednesday, March 20, 2013 1:22 AM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu;
> balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-tegra@vger.kernel.org; devicetree-discuss@lists.ozlabs.org
> Subject: Re: [PATCH 0/7] USB: PHY: Tegra: registering TEGRA USB PHY as
> platform driver
> 
> On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
> > As part of this series, apart from patch containing changes to register
> TEGRA
> > USB PHY driver as platform driver, prepared below patches:
> > 1. Re-arranging & adding new DT properties.
> > 2. Getting various params from DT properties added.
> > 3. code clean up.
> 
> Venu, I'm curious whether these patches were tested at all. I have found
> at least two significant problems with trivial testing:

Stephen,
Initially started testing after applying each and every patch.
Like that tested till first 5 patches.
As did not see any issues till then, applied rest 2 patches at once and tested with that.
Though did not see mouse getting vbus on the 1st boot, Vbus was coming fine after disconnect and connect.
Hence did not test thereafter.

After checking your current mail, tried now and observed that there seems to be some real issue with patch#7 only. (As tried now after applying till patch# 6 and did not see this issue).
Will debug further on patch#7 and update with proper fix after addressing your other comments.

Thanks for the review & heads up,
venu

> 
> 1)
> 
> "reboot" or "shutdown -h now" both cause the following crash, with or
> without any USB devices plugged in (or ever having been plugged in):
> 
> > [  355.836288] Unable to handle kernel NULL pointer dereference at virtual
> address 00000028
> > [  355.847961] pgd = ed620000
> > [  355.854093] [00000028] *pgd=00000000
> ...
> > [  356.146728] [<c02e5978>] (tegra_ehci_hcd_shutdown+0x18/0x2c) from
> [<c0279edc>] (platform_drv_shutdown+0x18/0x1c)
> > [  356.160379] [<c0279edc>] (platform_drv_shutdown+0x18/0x1c) from
> [<c027703c>] (device_shutdown+0x34/0x188)
> > [  356.173464] [<c027703c>] (device_shutdown+0x34/0x188) from
> [<c0034650>] (kernel_restart_prepare+0x34/0x3c)
> > [  356.186668] [<c0034650>] (kernel_restart_prepare+0x34/0x3c) from
> [<c0034664>] (kernel_restart+0xc/0x4c)
> > [  356.199637] [<c0034664>] (kernel_restart+0xc/0x4c) from [<c0034858>]
> (sys_reboot+0x1ac/0x1d8)
> > [  356.211704] [<c0034858>] (sys_reboot+0x1ac/0x1d8) from [<c000e2c0>]
> (ret_fast_syscall+0x0/0x30)
> > [  356.223965] Code: ebfe4b27 e5903000 e24300e8 e5133044 (e5933028)
> > [  356.233896] ---[ end trace 088d89482b4af176 ]---
> 
> 2)
> 
> The first time enumeration USB devices is attempted on a port fails. For
> devices that are plugged in at boot, this means that to get them
> working, they must be unplugged and re-plugged after boot. For devices
> that are not plugged in at boot, this means they must be plugged,
> unplugged, and then plugged in again.
> 
> This is obviously problematic in and of itself. This is especially true
> for boards like Harmony that have a built-in USB hub and network chip. I
> didn't actually test this, but I assume that they cannot be made to work
> at all with this patch series, since they cannot be unplugged.
> 
> The failed enumeration is accompanied by the following message:
> 
> [    2.451530] hub 3-0:1.0: unable to enumerate USB device on port 1
> 
> Both of these problems reproduce on at least boards Ventana and
> Seaboard(Springbank), although I assume that all boards are affected.
