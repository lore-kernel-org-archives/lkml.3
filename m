Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab3FDRRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:17:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5053 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3FDRRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:17:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 04 Jun 2013 10:16:42 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'bhelgaas@google.com'" <bhelgaas@google.com>,
        "'olof@lixom.net'" <olof@lixom.net>,
        "'mturquette@linaro.org'" <mturquette@linaro.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>
CC: "'thierry.reding@avionic-design.de'" 
	<thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>
Date: Tue, 4 Jun 2013 22:47:14 +0530
Subject: FW: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
Thread-Topic: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
Thread-Index: Ac5eJJI8JPgZ1AzzQgO0AIUtzUo7LQAAxpagAACt1yAAAPSfMAC1ABKwAAnOllAAB1umsA==
Message-ID: <C79B248886DD134989C8FF6B096A91AB91B603D82B@BGMAIL01.nvidia.com>
References: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com>
 <1368010660-31465-4-git-send-email-jagarwal@nvidia.com>
 <518A8596.7070702@wwwdotorg.org>
 <C79B248886DD134989C8FF6B096A91AB91B4886B5D@BGMAIL01.nvidia.com>
 <C79B248886DD134989C8FF6B096A91AB91B4886B6C@BGMAIL01.nvidia.com>
 <C79B248886DD134989C8FF6B096A91AB91B616BE9B@BGMAIL01.nvidia.com>
 <51A62042.7070304@wwwdotorg.org>
 <C79B248886DD134989C8FF6B096A91AB91B616BEA6@BGMAIL01.nvidia.com>
 <51A794A4.1010502@wwwdotorg.org>
 <C79B248886DD134989C8FF6B096A91AB91B616BEAD@BGMAIL01.nvidia.com>
 <51A8DE3A.6080503@wwwdotorg.org>
 <C79B248886DD134989C8FF6B096A91AB91B616BEB3@BGMAIL01.nvidia.com>
 <C79B248886DD134989C8FF6B096A91AB91B616BEB4@BGMAIL01.nvidia.com>
 <C79B248886DD134989C8FF6B096A91AB91B616BEB5@BGMAIL01.nvidia.com>
 <C79B248886DD134989C8FF6B096A91AB91B616BEBE@BGMAIL01.nvidia.com>
 <C79B248886DD134989C8FF6B096A91AB91B616BEC1@BGMAIL01.nvidia.com>
In-Reply-To: <C79B248886DD134989C8FF6B096A91AB91B616BEC1@BGMAIL01.nvidia.com>
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

<Forwarding to bigger aliases>

Anybody aware of hang in r8169 driver over pcie interface mentioned at bottom of this mail?

-----Original Message-----
From: Jay Agarwal 
Sent: Tuesday, June 04, 2013 7:17 PM
To: 'Stephen Warren'
Cc: 'thierry.reding@avionic-design.de'
Subject: RE: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu

> > > > > On 05/31/2013 06:17 AM, Jay Agarwal wrote:
> > > > > >>> I have taken care of all your comments, but Ethernet 
> > > > > >>> device is not working
> > > > > >> for me neither on cardhu nor harmony.
> > > > > >>> Could be related to my process or board, Currently 
> > > > > >>> debugging
> this.
> > > > > >>
> > > > > >> Are you talking about a PCIe-based Ethernet device on 
> > > > > >> Harmony, or the one that's built into the board?
> > > > > >>
> > > > > >> The on-board Ethernet device is USB, and should work fine 
> > > > > >> already, and irrespective of any PCIe patches.
> > > > > >
> > > > > > No I am talking about ethernet over PCIe interface.  There 
> > > > > > is no problem
> > > > > with built-in ethernet over USB.
> > > > > >
> > > > > >> I have only tried an XHCI USB controller in the PCIe slot 
> > > > > >> on Harmony, so I can't say if Ethernet not working is a 
> > > > > >> regression or not. Does the Ethernet device work with just 
> > > > > >> Thierry's patches and not
> > > > yours?
> > > > > >
> > > > > > It does not work w/o any of my patches also.
> > > > > >
> > > > > > Thierry,
> > > > > > Have you verified any ethernet card working on harmony?
> > > > > > I am using Broadcom Ethernet card with TIGON3 driver, but it 
> > > > > > does not
> > > > > work although PCIe enumeration and driver probe looks fine as
> > > attached.
> > > > > > Any idea?
> > > > >
> > > > > Oh, one thing to consider here: PCIe interrupts don't work 
> > > > > correctly when
> > > > > LP2 is enabled, at least in the upstream kernel. It's 
> > > > > something I've been trying to investigate, but haven't tracked down yet.
> > > > >
> > > > > Anyway, you need to disable the LP2 CPU power management state 
> > > > > for sure.
> > > > > Hopefully this will solve the issue for you. One way to do 
> > > > > this is the following patch, although we need a better 
> > > > > solution before we can actually merge anything:
> > > > >
> > > > > https://patchwork.kernel.org/patch/2525151/
> > > > Stephen,
> > > > This patch also did not resolve the issue although I do get 
> > > > "Disabling
> > > > LP2 cpuidle state..."  message in logs.
> > >
> > > It stucks as below:
> > >
> > > root@localhost:~# dhclient eth0
> > > [ 1444.579544] smsc95xx 3-1.1:1.0 eth0: hardware isn't capable of 
> > > remote wakeup [ 1444.587300] IPv6: ADDRCONF(NETDEV_UP): eth0: link 
> > > is not ready
> >
> > My system does not have ping command, so dhclient fails like below:
> > /sbin/dhclient-script: line 325: ping: command not found
> >
> > So I provided static IP as : ifconfig eth0 <IP> but it also did not help.
> 
>  Actually sorry, I was using wrong Ethernet interface(eth0) on 
> harmony, but correct one is eth1(over pcie interface) which works fine 
> on Thierry's repo after applying patches to disable LP2.
> Now I will try after applying my patches on both harmony and cardhu.

Ethernet is working on harmony is working w/ & a/o my patches but cardhu is hanging as below:

root@localhost:~# ifconfig eth0 10.19.65.115 [  102.525245] r8169 0000:03:00.0 eth0: unable to load firmware patch rtl_nic/rtl8168e-3.fw (-2) [  102.951516] r8169 0000:03:00.0 eth0: rtl_phyar_cond == 1 (loop: 20, delay: 25).
<System hangs here..>

1. Harmony is using Broadcom pcie Ethernet card and cardhu is using realtek one.
2. Enumeration and lspci seems to be fine though.
3. I tried applying similar patches for disabling LP2 for tegra 3 as well but it did not help.
4. Any idea/opinion?


