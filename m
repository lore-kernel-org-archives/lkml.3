Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab3EOR2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:28:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6982 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab3EOR2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:28:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 15 May 2013 10:24:44 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'Stephen Warren'" <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "olof@lixom.net" <olof@lixom.net>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Juha Tukkinen <jtukkinen@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
Date: Wed, 15 May 2013 22:58:22 +0530
Subject: RE: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
Thread-Topic: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
Thread-Index: Ac5MDiVYvwys7HTSTmeNS4cCuSA+NgFgtlKg
Message-ID: <C79B248886DD134989C8FF6B096A91AB91B4886B5D@BGMAIL01.nvidia.com>
References: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com>
 <1368010660-31465-4-git-send-email-jagarwal@nvidia.com>
 <518A8596.7070702@wwwdotorg.org>
In-Reply-To: <518A8596.7070702@wwwdotorg.org>
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


> On 05/08/2013 04:57 AM, Jay Agarwal wrote:
> > - Enable PCIe controller on Cardhu
> > - Only port 2 is connected on this board
> > - Add regulators required for Tegra30
> > - Patch is based on remotes/gitorious_thierryreding_linux/tegra/next
> > - and should be applied on top of this.
> 
> > diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi
> > b/arch/arm/boot/dts/tegra30-cardhu.dtsi
> 
> > +	pcie-controller {
> > +		status = "okay";
> > +		pex-clk-supply = <&pex_hvdd_3v3_reg>;
> > +		vdd-supply = <&ldo1_reg>;
> > +		avdd-supply = <&ldo2_reg>;
> > +
> > +		pci@3,0 {
> > +			status = "okay";
> > +		};
> > +	};
> 
> So, if I apply this series, I do see the PCIe bridge and Ethernet device get
> enumerated, but I don't see the USB3 controller get enumerated. I believe
> that is a PCIe device behind the same bridge on the same Tegra PCIe port.
> Shouldn't this device show up?
[>]  I have also reproduced this problem. I see somehow no non-prefetchable memory is assigned to any of pcie devices.
Probably that is the reason for USB3 (pci 0000:04:00.0) not getting enumerated since it uses only non-prefetchable memory.
