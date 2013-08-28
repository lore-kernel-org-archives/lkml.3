Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3H1LPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:15:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41725 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755115Ab3H1LPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:15:52 -0400
Date: Wed, 28 Aug 2013 13:15:48 +0200
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
Message-ID: <20130828131548.0009d613@skate>
In-Reply-To: <521DD057.4040208@gmail.com>
References: <20130828113459.48ecbb34@armhf>
	<521DCD33.2070008@gmail.com>
	<20130828121943.1c8327ca@skate>
	<521DD057.4040208@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Wed, 28 Aug 2013 12:26:31 +0200, Sebastian Hesselbarth wrote:

> >> as Mark Brown already took the bindings patch for above generic
> >> compatible, how are we going to discriminate different
> >> implementations/features of Dove, Kirkwood, and Armada 370?
> >
> > I agree that mvebu-audio is not a really good compatible string. It
> > should use the first SoC that introduced the IP block, so that if
> > future SOCs have variations, we can introduce separate compatible
> > strings.
> >
> > So for now, the compatible string should be kirkwood-audio.
> 
> Unfortunately, mvebu-audio has already been taken by Mark. Also, we
> know the differences for the three SoCs now and should have a compatible
> for each (and maybe mvebu-audio for fallback).

For 3.12, right? So 3.12 hasn't been released yet, so it's still time
to fix this.

> Also, we'll need to distinguish between the different audio controllers
> on a single SoC, i.e. i2s0 and i2s1. I suggest checking the (phys) reg
> base passed.

For what reason does the driver needs to know whether it's the instance
0 or instance 1 ? If it's needed for some specific reason, then there
should probably be something like marvell,i2s-channel-id = <0> and
marvell,i2s-channel-id = <1>.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
