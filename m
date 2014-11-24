Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaKXXAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 18:00:00 -0500
Received: from gloria.sntech.de ([95.129.55.99]:58074 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaKXW76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:59:58 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 15/15] metag: tz1090: add TZ1090 clocks to device tree
Date: Tue, 25 Nov 2014 00:03:43 +0100
Message-ID: <5932816.ccTTaBqqIv@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141121100647.GF12456@jhogan-linux.le.imgtec.org>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com> <2363265.Y6kZ4TuTy5@diego> <20141121100647.GF12456@jhogan-linux.le.imgtec.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 21. November 2014, 10:06:47 schrieb James Hogan:
> On Thu, Nov 20, 2014 at 01:56:24PM +0100, Heiko Stübner wrote:
> > I don't know enough about your clock structure, but it looks quite a bit
> > like Mike's mail from May [0] may apply here too.
> > 
> > The register layout also suggests that it is indeed one clock ip-block:
> > 
> > 0x02005908 0x4	CR_TOP_CLKSWITCH
> > 0x0200590c 0x4	CR_TOP_CLKENAB
> > 0x02005950 0x4	CR_TOP_SYSPLL_CTL0
> > 0x02005954 0x4	CR_TOP_SYSPLL_CTL1
> > 0x02005988 0x4	CR_TOP_CLKSWITCH2
> > 0x0200598c 0x4	CR_TOP_CLKENAB2
> > ...
> > 
> > 
> > [0] https://lkml.org/lkml/2014/5/14/715
> 
> Thanks, that does make sense. It's probably more like 4 memory regions
> ("top" level, "perip" peripheral registers, "hep" high end peripheral
> registers, and "pdc" powerdown controller registers), but it could
> certainly still have a single binding with multiple memory regions to
> simplify the clock specifiers.

It could also make sense to have 4 clock controller nodes for those. I guess 
it all depends on how the hardware is layed out.

For example on Rockchip SoCs, all of this is contained in the "APB CRU" (Clock 
and Reset Unit) with a memory region of <0x20000000 0x4000> - so here one 
hardware-block that contains all the clocks and also the reset controller.

On the other hand it might very well be more than one ip-block on your 
platform. 

So I guess it comes down to looking at the memory map [or documentation :-) ] 
to determine how many ip blocks there really are.


Heiko
