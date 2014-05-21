Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069AbaEUAIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 20:08:19 -0400
Received: from prifuk.cz ([31.31.77.140]:33072 "EHLO smtp.devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaEUAIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 20:08:18 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: simon@mungewell.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
Date: Wed, 21 May 2014 02:08:13 +0200
Message-ID: <1777829.p5KaJDSX63@sigyn>
User-Agent: KMail/4.13.1 (Linux/3.14.1-1-my-rd; KDE/4.13.1; x86_64; ; )
In-Reply-To: <7e57db42a261a54d38a3a7bb068c3ce2.squirrel@mungewell.org>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net> <6970969.ej8OFzkVkO@sigyn> <7e57db42a261a54d38a3a7bb068c3ce2.squirrel@mungewell.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 of May 2014 19:45:44 simon@mungewell.org wrote:
> >> Regarding the question of emulated vs. real effects, can we extend the
> >> API
> >> so that applications can know which effects are really supported, and
> >> enable/disable emulation somehow?
> > 
> > I suppose that a few extra flags (FF_PERIODIC_EMULATED etc.) defined in
> > "uapi/linux/input.h" should suffice.
> 
> The only problem is that we probably want to maintain backward
> compatibility so that older apps still see 'PERIODIC' (even though it is
> emulated).
> --
> #define FF_RUMBLE	0x50
> #define FF_PERIODIC	0x51
> #define FF_CONSTANT	0x52
> #define FF_SPRING	0x53
> #define FF_FRICTION	0x54
> #define FF_DAMPER	0x55
> #define FF_INERTIA	0x56
> #define FF_RAMP		0x57
> --
> 
> Do we therefore have to list extra items in our capabilities?
> --
> static const signed short lg4ff_wheel_effects[] = {
> 	FF_CONSTANT,
> 	FF_PERIODIC,
> 	FF_PERIODIC_NOT_EMULATED,
> 	FF_AUTOCENTER,
> 	-1
> };
> --
> 
> Simon

Actually I was thinking something like this:

"input.h"
#define FF_DAMPER	0x55
#define FF_INERTIA	0x56
#define FF_RAMP		0x57
+# define FF_PERIODIC_EMULATED	0x58
+# define FF_RUMBLE_EMULATED	0x59

and

in the future "library-like" reimplementation of MLNX:
#define EMULATE_PERIODIC BIT(0)
#define EMULATE_RUMBLE BIT(1)

kfflib_init(..., EMULATE_PERIODIC | EMULATE_RUMBLE);
for full emulation.

Michal


