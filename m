Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbaBDTv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:51:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbaBDTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:51:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Date: Tue, 4 Feb 2014 20:50:43 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com> <13031998.NR888KZWhk@wuerfel> <CAL_JsqLN4RjVzNCfZ50K44RcP61Z8zFOVnpY1+CfVFz_QnSBEg@mail.gmail.com>
In-Reply-To: <CAL_JsqLN4RjVzNCfZ50K44RcP61Z8zFOVnpY1+CfVFz_QnSBEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402042050.43837.arnd@arndb.de>
X-Provags-ID: V02:K0:XpIA1aR/e74YfCKgsvQl/LmCs4LInJGnHXDJy6wIsLN
 W1HrEv5nSeB4ku8D63lkGT5V4AAtAszqrzYSVgYxGa2pOvS899
 GyoYOS6vbmn9c9b8hpY9e9thn7hZep7qrT8htgBVESYZABjRDh
 FylvrHi35qVc+m5HgFP1CpS76EgfXSc5LFoYqzwAleRFKbpu44
 L2IITOgqgxPuOYCOnBSFGonUXfomgj5XV7GseEYGZFtbLZ0hwb
 bC91ZkNy1sXvy9HhCkeH+aQkKRrVlaS7BUob6AT90iK4vuk8d0
 Aw7s9h8jsyX0WhtlkjxC1m9xLeW+HpKbYXfggM0Z0+QpTHbpPp
 mhaEDD9/4ORMO4srml9VwHMw8zWVGwqvSXnsThCux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 February 2014, Rob Herring wrote:
> > Here is how a sane person would read SBSA to create a compliant
> > implementation:
> 
> s/sane/software/

> > Here is how a crazy person would read the same sentence in the SBSA:
> 
> s/crazy/hardware/

Not much of a difference, apparently ...

> My money is on the latter. I think non-PCI implementations of xHCI
> interfaces will be common. This was certainly the case at Calxeda in
> what was believed to be a SBSA compliant SOC.

I just looked up the EHCI and xHCI specs and am shocked to see that
the PCI config space access for both is an optional part of the
spec, so that assertion may well have been correct.

On the other hand, it does seem impossible to create a compliant
AHCI implementation without making it show up as a PCI function,
so any SBSA compliant SoC that contains AHCI already has to have
all the bits for doing the same on USB.

> However, I think PCI
> device or not is the least of the issues and all the other examples
> you list are the difficult ones to deal with.

Agreed. But if they get the difficult problems right, it's
trivial to also do the PCI config space either in the way
that Jason described, or as a separate PCI domain. In the worst
case, it could still be faked up by a secure-mode firmware
catching all config space accesses.

	Arnd
