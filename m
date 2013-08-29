Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3H2KGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:06:18 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:43717 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab3H2KGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:06:17 -0400
Date: Thu, 29 Aug 2013 12:07:04 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
Message-ID: <20130829120704.410ad309@armhf>
In-Reply-To: <521DEA20.8020103@gmail.com>
References: <20130828113459.48ecbb34@armhf>
	<521DCD33.2070008@gmail.com>
	<20130828121943.1c8327ca@skate>
	<521DD057.4040208@gmail.com>
	<20130828131548.0009d613@skate>
	<521DE2B3.9050508@gmail.com>
	<20130828135827.2307c89e@skate>
	<521DEA20.8020103@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 14:16:32 +0200
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

	[snip]
> > Though, if the difference between the two units is the availability of
> > SPDIF support, then we shouldn't encode the channel number, but instead
> > the availability of SPDIF, i.e:
> >
> > 	audio0 {
> > 		reg = <... ...>;
> > 		compatible = "marvell,kirkwood-audio";
> > 		marvell,has-spdif;  
> 
> Agree, if you make it "marvell,has-spdif-in" and "marvell,has-spdif-out"
> Dove has either i2s-only or i2s+spdifo, kirkwood has i2s+spdifo+spdifi
> for the one audio controller available. Can't tell for Armada 370.
> 
> BTW, you might have followed some of the DT discussions with Mark
> before; as he insists on having a separate sound card node, he might
> argue that above property should be part of that node instead.

Yes. For the Cubox, the card will be described by something like:

	sound {
		compatible = "simple-audio";
		audio-controller = <&audio1>;
		audio-codec = <&spdif>;
		codec-dai-name = "dit-hifi";
	};

with:

	spdif: spdif {
 		compatible = "linux,spdif-dit";
	};

Then, the audio driver will know about s/pdif on the first open.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
