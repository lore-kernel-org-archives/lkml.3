Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbaEISNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:13:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46297 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbaEISNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:13:17 -0400
Date: Fri, 9 May 2014 19:12:11 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Xiubo Li <Li.Xiubo@freescale.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 1/2] dt/bindings: Add the DT binding documentation
 for endianness
Message-ID: <20140509181211.GF16418@e106331-lin.cambridge.arm.com>
References: <1399601073-19278-1-git-send-email-Li.Xiubo@freescale.com>
 <1399601073-19278-2-git-send-email-Li.Xiubo@freescale.com>
 <20140509163243.GD16418@e106331-lin.cambridge.arm.com>
 <20140509170255.GR12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509170255.GR12304@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 06:02:55PM +0100, Mark Brown wrote:
> On Fri, May 09, 2014 at 05:32:43PM +0100, Mark Rutland wrote:
> > On Fri, May 09, 2014 at 03:04:32AM +0100, Xiubo Li wrote:
> 
> > > {big,little}-endian{,-*}: these are boolean properties, if absent
> > > meaning that the CPU and the Device are in the same endianness mode.
> 
> > That's not really true though. A device might usually be little-endian,
> > regardless of the endianness of a CPU. Some vendors may integrate it as
> > big-endian after a binding is added, and in the absence of a specified
> > endianness a driver is likely to assume LE.
> 
> The default should be device specific rather than binding specific.

I'm taking binding here to mean the binding for a praticular device
rather than a class binding, so there's only a subtle distinction
between the two.

It's entirely possible that two developers independently come up with
bindings for something that is later realised to be the same device
(just integrated differently), for which they choose opposite defaults.

In that case the default is binding-specific rather than device
specific, though I would hope that in the vast majority of cases there
is only one binding per device, at which point the distinction is
meaningless.

Cheers,
Mark.
