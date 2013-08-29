Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3H2JiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:38:01 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:41966 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878Ab3H2JiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:38:00 -0400
Date: Thu, 29 Aug 2013 11:38:48 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
Message-ID: <20130829113848.6d8f7f21@armhf>
In-Reply-To: <521E5438.90109@cogentembedded.com>
References: <20130828113459.48ecbb34@armhf>
	<521E5438.90109@cogentembedded.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 23:49:12 +0400
Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> wrote:

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
> 
>      According to ePAPR [1] the node should be called "sound", not 
> "audio-controller".
> 
> > +				compatible = "marvell,mvebu-audio";
> > +				reg = <0xb0000 0x2210>;
> > +				interrupts = <19>, <20>;
> > +				clocks = <&gate_clk 12>;
> > +				clock-names = "internal";
> > +				status = "disabled";
> > +			};

AFAIK, "sound" describes the global audio subsystem. For the Cubox,
this will be done by something like:

	sound {
		compatible = "simple-audio";
		audio-controller = <&i2s1>;
		audio-codec = <&spdif>;
		codec-dai-name = "dit-hifi";
	};

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
