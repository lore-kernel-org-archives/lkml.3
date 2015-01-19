Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbbASPSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:18:32 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:61946 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbASPSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:18:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rameshwar Sahu <rsahu@apm.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, ddutile@redhat.com,
        jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
Subject: Re: [PATCH v3 2/3] arm64: dts: Add APM X-Gene DMA device and DMA clock DTS nodes
Date: Mon, 19 Jan 2015 16:17:39 +0100
Message-ID: <4015362.jQuStL4p6a@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFd313wyVqsqGNdxrAzmGCCYd-RAEcrX6f4y2Gngi44OOkbx-Q@mail.gmail.com>
References: <1421671269-19441-1-git-send-email-rsahu@apm.com> <2407238.x2YxDm0cd4@wuerfel> <CAFd313wyVqsqGNdxrAzmGCCYd-RAEcrX6f4y2Gngi44OOkbx-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:8xMx4XSwtdUssuImT94tkIQA4DZMHTQw6CeNtbqjF0+cnMiTnC7
 yb3D4mcbCjrEK/3zX2NHEuZZGWAyWyiB/nJ2oihD+jtKxyPtzhS/yQm5Z0uUnFSzth7/ELA
 gKLvnoBKQ5Xc5DF1itNdKs1O/yb8FweEO706dlyAm6g/VeYmpWS1BSXRBF4CqwCyDj6WoXk
 wyGxfSn3TGHTqvNScmNFw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2015 20:11:22 Rameshwar Sahu wrote:
> 
> >
> > The value should be
> >
> >         dma-ranges = <0x40 0x0 0x40 0x0 0x200 0>;
> >
> 
> then it should be :
> 
> dma-ranges = <0x40 0x0 0x40 0x0 0x400 0>;
> 
> 
> to say that any DMA to physical addresses from 0 to 0x3f.ffffffff

No, the property above is for a bus that extends from
0x40.00000000 to 0x43f.ffffffff

The first tuple is the address that is used for the local
bus, the second one is the address that it gets translated to
on the parent bus, and the third tuple is the length.

> > is disallowed and dma to physical addresses from 0x40.00000000
> > to 0x23f.ffffffff is allowed and gets translated using an
> > identity mapping.
> >
> > I also see that on Mustang, all memory is outside of this range,
> >
> 
> Do you mean all other device controller node in DT here??
> Basically these are all device controller memory, as what I understood is
> dma-ranges tells about DDR ranges like start address of DDR
> and length.

It has absolutely nothing to do with where the DDR memory resides,
only which addresses are valid on a particular bus, like the
ranges property for the opposite direction. This is usually set
up in some control register for the bus, and you should use the
same value here.

	Arnd
