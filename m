Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3H1L6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:58:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42063 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752724Ab3H1L6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:58:32 -0400
Date: Wed, 28 Aug 2013 13:58:27 +0200
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
Message-ID: <20130828135827.2307c89e@skate>
In-Reply-To: <521DE2B3.9050508@gmail.com>
References: <20130828113459.48ecbb34@armhf>
	<521DCD33.2070008@gmail.com>
	<20130828121943.1c8327ca@skate>
	<521DD057.4040208@gmail.com>
	<20130828131548.0009d613@skate>
	<521DE2B3.9050508@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Wed, 28 Aug 2013 13:44:51 +0200, Sebastian Hesselbarth wrote:

> > For 3.12, right? So 3.12 hasn't been released yet, so it's still time
> > to fix this.
> 
> I guess, yes.

Jean-François, could you cook and submit a patch to change the
compatible string?

> >> Also, we'll need to distinguish between the different audio controllers
> >> on a single SoC, i.e. i2s0 and i2s1. I suggest checking the (phys) reg
> >> base passed.
> >
> > For what reason does the driver needs to know whether it's the instance
> > 0 or instance 1 ? If it's needed for some specific reason, then there
> > should probably be something like marvell,i2s-channel-id = <0> and
> > marvell,i2s-channel-id = <1>.
> 
> On Dove, audio1 has SPDIF out, audio0 hasn't. Russell also mentioned to
> get rid of "i2s" and use "audio" instead. Most SoC's controllers are
> i2s only but as soon as SPDIF comes into play, it is a different
> interface protocol.
> 
> I am fine with having a "marvell,channel-id" (no "i2s") to discriminate
> the instances, although reg offset should be sufficient.

Well, the reg offset is a possibility, but it's not really nice, and
would have to be adapted to each and every SoC even if the reset of the
audio IP is the same.

Though, if the difference between the two units is the availability of
SPDIF support, then we shouldn't encode the channel number, but instead
the availability of SPDIF, i.e:

	audio0 {
		reg = <... ...>;
		compatible = "marvell,kirkwood-audio";
		marvell,has-spdif;
	};

	audio1 {
		reg = <... ...>;
		compatible = "marvell,kirkwood-audio";
	};

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
