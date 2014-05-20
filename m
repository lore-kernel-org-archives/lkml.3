Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbaETXaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:30:10 -0400
Received: from host171.canaca.com ([67.55.55.225]:52193 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaETXaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:30:08 -0400
Message-ID: <1c6140633925b0838b7627e071e80761.squirrel@mungewell.org>
In-Reply-To: <537BD184.9090608@logitech.com>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
    <1818063.tFLKhAd1oy@sigyn>
    <20140514180558.GB30089@core.coreip.homeip.net>
    <2965006.XKYHWj9YzJ@sigyn> <537B9FAE.9070602@logitech.com>
    <8c45868c3cd4333d1098bdbc0fa83a2e.squirrel@mungewell.org>
    <537BD184.9090608@logitech.com>
Date: Tue, 20 May 2014 19:30:02 -0400
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
From: simon@mungewell.org
To: "Roland Bosa" <rbosa@logitech.com>
Cc: simon@mungewell.org,
        =?iso-8859-1?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, elias.vds@gmail.com, anssi.hannula@iki.fi
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> IMO, there are two types of games. The "arcade" ones, which have a set
> of 'canned' force effects, which play whenever an event happens in game.
> And the "simulation" ones, which base the game on a physics engine. The
> latter can redirect some variables of their engine to the input layer
> and typically drive a constant force and maybe a spring/damper too.
>
> For the first type, you might want to keep a centering spring active all
> the time. Maybe you want to tweak the gain in the game settings. Maybe
> there's a gain for the centering and one for the special effects. The
> canned effects are mostly periodics with varying waveform, duration,
> amplitude and envelope. That's about it.

Sounds like these are the effect files produced by FEdit tool (from MS
DirectX SDK), and/or played back by pressing buttons when configuring the
Logitech driver on Windows ('wooden bridge', etc)...

Do you know if there is a mechanism for playing these under Linux?

Under Windows do games just send a 'file' the DirectX driver, or do they
parse them into individual effects to send?

If format is known/public it shouldn't be hard to write a userland client
to play them back. If this needs to be supported in the kernel that would
be more problematic.

> For the second type, you don't want a centering spring. You typically
> will drive a constant force effect with the engine, with some sprinkled
> damping and maybe a slight spring here and there.
>
> I would personally put more weight and effort to get the second type
> properly implemented. The players of those games demand more realism and
> they need the subtle force changes to drive better than the competition.

I would agree, these are probably more higher 'priority' but I think that
the work Elias and Michal have done already implements these fairly well.

I assume that most AAA games, would implement these through some middle
layer. I think that is probably via Steam using SDL2 haptic API, we have
been testing against SDL2's 'testhaptic'.

Do you see another path (which we should be supporting/testing)?

> That means having a FF driver that can deal with many force updates per
> second without choking and a consistent, reproducible force output at
> the device, maybe even similar across varying devices. This translates
> into a decoupled design for accepting force updates and sending USB
> updates, as well as a device-specific layer to "calibrate" and "unify"
> the force responses across different models.

There was some discussion about rate limiting the USB packets to the
wheel, and how to deal if app updates too quickly. Is there an upper limit
for the wheel itself, or is it just the USB 'pipe' which is the limiting
factor?

Simon

