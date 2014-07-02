Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaGBEXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:23:14 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5980 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaGBEXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:23:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 01 Jul 2014 21:16:39 -0700
From: Vidya Sagar <vidyas@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "nagananda.chumbalkar@hp.com" <nagananda.chumbalkar@hp.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Krishna Thota <kthota@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 2 Jul 2014 09:53:03 +0530
Subject: RE: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE mode
Thread-Topic: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE
 mode
Thread-Index: Ac+VPe+dwGsFEL+/Tbitv8eGD5DPdAAbspGw
Message-ID: <113ACA888B71994BB56E5CF3704953486D8E9DF589@BGMAIL02.nvidia.com>
References: <1404198978-26593-1-git-send-email-vidyas@nvidia.com>
 <53B2CE15.7010403@wwwdotorg.org>
In-Reply-To: <53B2CE15.7010403@wwwdotorg.org>
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
> Sent: Tuesday, July 01, 2014 8:35 PM
> To: Vidya Sagar; bhelgaas@google.com; rjw@sisk.pl;
> nagananda.chumbalkar@hp.com; thierry.reding@gmail.com; Stephen
> Warren; Krishna Thota; linux-pci@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v1] PCI: enable ASPM configuration in PCIE POWERSAVE
> mode
> 
> On 07/01/2014 01:16 AM, Vidya Sagar wrote:
> > commit 1a680b7c moved pcie_aspm_powersave_config_link() out of
> > pci_raw_set_power_state() to pci_set_power_state() which would enable
> > ASPM. But, with commit db288c9c, which re-introduced the following
> > check
> > ./drivers/pci/pci.c: pci_set_power_state()
> > +   /* Check if we're already there */
> > +   if (dev->current_state == state)
> > +       return 0;
> > in pci_set_power_state(), call to pcie_aspm_powersave_config_link() is
> > never made leaving ASPM broken.
> > Fix it by not returning from when the above condition is true, rather,
> > jump to ASPM configuration code and exit from there eventually.
> 
> Out of curiosity, was this patch tested by running an umodified mainline
> kernel on a Tegra device, or is this simply a port from our downstream kernel,
> without any additional upstream testing?

I've tested port of this patch on downstream kernel and it works.
I've also tested this on thierry's code base (git://gitorious.org/thierryreding/linux.git) which has
upstream code for T124-Jetson-tk1.
Because of the L0s and L1 exit latencies exhibited by jetson-tk1 on-board Realtek Ethernet controller,
subsystem can't enable ASPM states on the end point,
 but as such I've verified the flow with the help of debug prints and they indicate that the patch is doing its job correctly.

