Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbaETXps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:45:48 -0400
Received: from host171.canaca.com ([67.55.55.225]:50939 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaETXpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:45:46 -0400
Message-ID: <7e57db42a261a54d38a3a7bb068c3ce2.squirrel@mungewell.org>
In-Reply-To: <6970969.ej8OFzkVkO@sigyn>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
    <2965006.XKYHWj9YzJ@sigyn>
    <865ad8dbc7ae0d13c045bd2a85cff2e2.squirrel@mungewell.org>
    <6970969.ej8OFzkVkO@sigyn>
Date: Tue, 20 May 2014 19:45:44 -0400
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
From: simon@mungewell.org
To: =?iso-8859-1?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>
Cc: simon@mungewell.org, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
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


>> Regarding the question of emulated vs. real effects, can we extend the
>> API
>> so that applications can know which effects are really supported, and
>> enable/disable emulation somehow?
>
> I suppose that a few extra flags (FF_PERIODIC_EMULATED etc.) defined in
> "uapi/linux/input.h" should suffice.

The only problem is that we probably want to maintain backward
compatibility so that older apps still see 'PERIODIC' (even though it is
emulated).
--
#define FF_RUMBLE	0x50
#define FF_PERIODIC	0x51
#define FF_CONSTANT	0x52
#define FF_SPRING	0x53
#define FF_FRICTION	0x54
#define FF_DAMPER	0x55
#define FF_INERTIA	0x56
#define FF_RAMP		0x57
--

Do we therefore have to list extra items in our capabilities?
--
static const signed short lg4ff_wheel_effects[] = {
	FF_CONSTANT,
	FF_PERIODIC,
	FF_PERIODIC_NOT_EMULATED,
	FF_AUTOCENTER,
	-1
};
--

Simon

