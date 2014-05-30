Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbaE3Tu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:50:59 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54944 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaE3Tu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:50:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robherring2@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Date: Fri, 30 May 2014 21:49:59 +0200
Message-ID: <5288123.eXagyPAxNq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_Jsq+tkFNpjSEZboT+o69B_Z3a8e-ZVKaYDmLwtkyYoPy6VQ@mail.gmail.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <4545972.cM7IP1qTXQ@wuerfel> <CAL_Jsq+tkFNpjSEZboT+o69B_Z3a8e-ZVKaYDmLwtkyYoPy6VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Dwg0+Xphz8ZXH6b1JXsHtzeZyonuF/Umpc6ZKU9KlQr
 LNzuJ6QRtE4SmxR6D2RPxoZ+l+4bp3jYpBvEBESgMGwZ2vvZl8
 pL2YwQrxkKosJzl2rEn9nOnLc/AsvLsbVjhBlL+uuBtoHgl0LV
 v/F27sJwR7UXCWkyf7iDvP9UlGk6jL0F3LiFoKEZxM1tHfpsKx
 jFGJfaL++5zloPo2tSw8kywaazEzHh/t9YS1HfX5ylrfY4BFwG
 KxFwEx+jfZFxa5XfLw1vCS0ENNm5UpyZTP6k7AiGcSDjayasNC
 +6m8uaPSgJFMcQWRx1TeulHlV5HC54nuMmUmCU98heHA5qnVwE
 GlYsak5hb6f7k98q9iYQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2014 14:31:55 Rob Herring wrote:
> On Fri, May 30, 2014 at 2:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 30 May 2014 08:16:05 Rob Herring wrote:
> >> On Fri, May 23, 2014 at 3:33 PM, Thierry Reding
> >> <thierry.reding@gmail.com> wrote:
> >> > From: Thierry Reding <treding@nvidia.com>
> >> > +IOMMU master node:
> >> > +==================
> >> > +
> >> > +Devices that access memory through an IOMMU are called masters. A device can
> >> > +have multiple master interfaces (to one or more IOMMU devices).
> >> > +
> >> > +Required properties:
> >> > +--------------------
> >> > +- iommus: A list of phandle and IOMMU specifier pairs that describe the IOMMU
> >> > +  master interfaces of the device. One entry in the list describes one master
> >> > +  interface of the device.
> >> > +
> >> > +When an "iommus" property is specified in a device tree node, the IOMMU will
> >> > +be used for address translation. If a "dma-ranges" property exists in the
> >> > +device's parent node it will be ignored. An exception to this rule is if the
> >> > +referenced IOMMU is disabled, in which case the "dma-ranges" property of the
> >> > +parent shall take effect.
> >>
> >> Just thinking out loud, could you have dma-ranges in the iommu node
> >> for the case when the iommu is enabled rather than putting the DMA
> >> window information into the iommus property?
> >>
> >> This would probably mean that you need both #iommu-cells and #address-cells.
> >
> > The reason for doing like this was that you may need a different window
> > for each device, while there can only be one dma-ranges property in
> > an iommu node.
> 
> My suggestion was that you also put the IDs in the dma-ranges as the
> first cell much as ranges for PCI encodes other information in the
> first cell. Then you can have an entry for each ID. The downside is
> another special case like PCI.
> 
> The argument for using #address-cells and #size-cells seems to be to
> align with how ranges work. If that's the route we want to go, then I
> say we should not stop there and actually use dma-ranges as well.
> Otherwise, I don't see the advantage over #iommu-cells.

I can see how dma-ranges in bus nodes work, it just doesn't seem to
have any reasonable meaning in the iommu node itself.

> > I don't understand the problem. If you have stream IDs 0 through 7,
> > you would have
> >
> >         master@a {
> >                 ...
> >                 iommus = <&smmu 0>;
> >         };
> >
> >         master@b {
> >                 ...
> >                 iommus = <&smmu 1;
> >         };
> >
> >         ...
> >
> >         master@12 {
> >                 ...
> >                 iommus = <&smmu 7;
> >         };
> >
> > and you don't need a window at all. Why would you need a mask of
> > some sort?
> 
> 1 master with 7 IDs like this:
> 
>          master@a {
>                  ...
>                  iommus = <&smmu 0> <&smmu 1> <&smmu 2> <&smmu 3>
> <&smmu 4> <&smmu 5> <&smmu 6> <&smmu 7>;
>          };
> 
> If there was any sort of window, then it is almost certainly the same
> window for each ID.

Ok, I see. In that case you'd probably want to have #address-cells = <1>
and #size-cells = <1> and give a range of IDs like

	iommus = <&smmu 0 8>;

Do you think that ranges can have a meaningful definition with the ARM
SMMU stream IDs?

	Arnd
