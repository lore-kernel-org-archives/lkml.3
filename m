Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3FKEpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 00:45:25 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11879 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab3FKEpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 00:45:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 10 Jun 2013 21:43:54 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'Thierry Reding'" <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
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
Date: Tue, 11 Jun 2013 10:13:38 +0530
Subject: RE: [PATCH V3 2/4] ARM: tegra: pcie: Add tegra3 support
Thread-Topic: [PATCH V3 2/4] ARM: tegra: pcie: Add tegra3 support
Thread-Index: Ac5mE9G/hIAh6hM8TwGLvktSM/RqBwASbsvg
Message-ID: <C79B248886DD134989C8FF6B096A91AB91B616BEED@BGMAIL01.nvidia.com>
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
 <1370372252-4332-2-git-send-email-jagarwal@nvidia.com>
 <51AE3D3B.6080102@wwwdotorg.org> <20130610195028.GB25859@mithrandir>
In-Reply-To: <20130610195028.GB25859@mithrandir>
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

> * PGP Signed by an unknown key
> 
> On Tue, Jun 04, 2013 at 01:17:15PM -0600, Stephen Warren wrote:
> > On 06/04/2013 12:57 PM, Jay Agarwal wrote:
> [...]
> > >  struct tegra_pcie_port {
> > > @@ -384,7 +408,7 @@ static int tegra_pcie_read_conf(struct pci_bus
> *bus, unsigned int devfn,
> > >  		struct tegra_pcie_port *port;
> > >
> > >  		list_for_each_entry(port, &pcie->ports, list) {
> > > -			if (port->index + 1 == slot) {
> > > +			if (port->index == slot) {
> >
> > This and the equivalent change in tegra_pcie_write_conf() seem like a
> > bug-fix unrelated to the addition of Tegra30 support. Hence, they
> > should be a separate patch.
> 
> What exactly is this change supposed to fix? The description doesn't provide
> any details about why this is required. Furthermore this was done on
> purpose to model the Tegra PCIe controller according to what typical Linux
> systems provide.

I have mentioned it in description as -> "Corrected logic in read/write config space to display right device number on bus 0"

> Device 0:00.0 is usually the root complex, and device 0:01.0, 0:02.0 etc are
> the root ports. The change proposed above makes 0:00.0 the first root port,
> therefore breaking what systems usually expect.
> 
I was seeing root port 2 in cardhu being enumerated as pci_bus 0000:03, which I thought should be pci_bus 0000:02, so made this change.

> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
