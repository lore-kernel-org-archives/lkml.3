Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858AbaE3TGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:06:51 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:50067 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaE3TGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:06:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Date: Fri, 30 May 2014 21:06:16 +0200
Message-ID: <4545972.cM7IP1qTXQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqKumG1PSFoVfeGpLLG+MjXFeF4aUjun=vv1BJpaxk0Byg@mail.gmail.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <CAL_JsqKumG1PSFoVfeGpLLG+MjXFeF4aUjun=vv1BJpaxk0Byg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Srl5ALsrqy79FBxN0HyvBfmaEfWG4IiSw2HHUAiE1fz
 NEoAP0/r2l56JLRH6fhivu0BPbQTY9xnAkBx5Mvwgv0fm9Vumc
 5G9fZdroQ3cVsBt+CeCIv0DFuT7bhWjxdEoBiNSjw+1MXJy7VQ
 wJut5hMfbcw8+0c78gv0Xf/+kmPHeU4tq8ccnssLD5V8Ts0KZZ
 Lv6pdTQmwCaiw7+9SvWF+shfNY1AUWYr/FKGLMjVwZ5tRHbMIa
 ogIYGrJJSp3+qLY4HoKsaW4KD4GH1UKbP9IFIDwVC5hw34eyBL
 /Ac0yHNvg68yBmJUGHcnoGtvDAf5pQ3uPJakYBLgXKDdo1rLeE
 aUKFPizrEZcVUOUIF+zk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2014 08:16:05 Rob Herring wrote:
> On Fri, May 23, 2014 at 3:33 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > From: Thierry Reding <treding@nvidia.com>
> > +IOMMU master node:
> > +==================
> > +
> > +Devices that access memory through an IOMMU are called masters. A device can
> > +have multiple master interfaces (to one or more IOMMU devices).
> > +
> > +Required properties:
> > +--------------------
> > +- iommus: A list of phandle and IOMMU specifier pairs that describe the IOMMU
> > +  master interfaces of the device. One entry in the list describes one master
> > +  interface of the device.
> > +
> > +When an "iommus" property is specified in a device tree node, the IOMMU will
> > +be used for address translation. If a "dma-ranges" property exists in the
> > +device's parent node it will be ignored. An exception to this rule is if the
> > +referenced IOMMU is disabled, in which case the "dma-ranges" property of the
> > +parent shall take effect.
> 
> Just thinking out loud, could you have dma-ranges in the iommu node
> for the case when the iommu is enabled rather than putting the DMA
> window information into the iommus property?
> 
> This would probably mean that you need both #iommu-cells and #address-cells.

The reason for doing like this was that you may need a different window
for each device, while there can only be one dma-ranges property in 
an iommu node.

> > +
> > +Optional properties:
> > +--------------------
> > +- iommu-names: A list of names identifying each entry in the "iommus"
> > +  property.
> 
> Do we really need a name here? I would not expect that you have
> clearly documented names here from the datasheet like you would for
> interrupts or clocks, so you'd just be making up names. Sorry, but I'm
> not a fan of names properties in general.

Good point, this was really overdesign by modeling it after other
subsystems that can have a use for names.
 
> > +Multiple-master IOMMU:
> > +----------------------
> > +
> > +       iommu {
> > +               /* the specifier represents the ID of the master */
> > +               #address-cells = <1>;
> > +               #size-cells = <0>;
> > +       };
> > +
> > +       master {
> > +               /* device has master ID 42 in the IOMMU */
> > +               iommus = <&/iommu 42>;
> > +       };
> 
> Presumably the ID would be the streamID on ARM's SMMU. How would a
> master with 8 streamIDs be described? This is what Calxeda midway has
> for SATA and I would expect that to be somewhat common. Either you
> need some ID masking or you'll have lots of duplication when you have
> windows.

I don't understand the problem. If you have stream IDs 0 through 7,
you would have

	master@a {
		...
		iommus = <&smmu 0>;
	};

	master@b {
		...
		iommus = <&smmu 1;
	};

	...

	master@12 {
		...
		iommus = <&smmu 7;
	};

and you don't need a window at all. Why would you need a mask of
some sort?

	Arnd
