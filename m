Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3H1KUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:20:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41351 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752513Ab3H1KT7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:19:59 -0400
Date: Wed, 28 Aug 2013 12:19:43 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
Message-ID: <20130828121943.1c8327ca@skate>
In-Reply-To: <521DCD33.2070008@gmail.com>
References: <20130828113459.48ecbb34@armhf>
	<521DCD33.2070008@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian, Jean-François,

On Wed, 28 Aug 2013 12:13:07 +0200, Sebastian Hesselbarth wrote:
> On 08/28/2013 11:34 AM, Jean-Francois Moine wrote:
> > This patch adds the nodes to instantiate the audio devices of the Dove
> > boards.
> >
> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> > ---
> >   arch/arm/boot/dts/dove.dtsi                  | 18 ++++++++++++++++++
> >   1 file changed, 18 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
> > index 499abad..78227e2 100644
> > --- a/arch/arm/boot/dts/dove.dtsi
> > +++ b/arch/arm/boot/dts/dove.dtsi
> > @@ -573,6 +573,24 @@
> >   					phy-handle = <&ethphy>;
> >   				};
> >   			};
> > +
> > +			i2s0: audio-controller@b0000 {
> > +				compatible = "marvell,mvebu-audio";
> 
> [added Gregory to Cc]
> 
> Jean-Francois,
> 
> as Mark Brown already took the bindings patch for above generic
> compatible, how are we going to discriminate different
> implementations/features of Dove, Kirkwood, and Armada 370?

I agree that mvebu-audio is not a really good compatible string. It
should use the first SoC that introduced the IP block, so that if
future SOCs have variations, we can introduce separate compatible
strings.

So for now, the compatible string should be kirkwood-audio.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
