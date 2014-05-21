Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaEUWms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:42:48 -0400
Received: from host171.canaca.com ([67.55.55.225]:53425 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaEUWmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:42:46 -0400
Message-ID: <77e93715d28deb2ec0508f9326f9102f.squirrel@mungewell.org>
In-Reply-To: <537D28E3.3000401@logitech.com>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
    <2965006.XKYHWj9YzJ@sigyn> <537B9FAE.9070602@logitech.com>
    <10859911.6zyzadbfH9@sigyn> <537BCB63.1020200@logitech.com>
    <CADbOyBQxC+Epv1kz8jsBKNgYGFO0R-UPBXvn_qV8Sqb6rNw+Og@mail.gmail.com>
    <537D28E3.3000401@logitech.com>
Date: Wed, 21 May 2014 18:42:40 -0400
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
From: simon@mungewell.org
To: "Roland Bosa" <rbosa@logitech.com>
Cc: "Elias Vanderstuyft" <elias.vds@gmail.com>,
        =?iso-8859-1?Q?=22Michal_Mal=C3=BD=22?= 
	<madcatxster@devoid-pointer.net>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "HID CORE LAYER" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Anssi Hannula" <anssi.hannula@iki.fi>,
        "Simon Wood" <simon@mungewell.org>
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


>> But 2 Spring effects with different offsets and non-zero effective
>> force can't be combined into a single slot (without streaming them
>> with Constant force), right?
>
> Yes - you cannot *download* two springs to a single slot. You need to
> choose (allocate) one of them. The winner gets the slot. The losers go
> somewhere else (they might get discarded, they might get simulated).

In reverse engineering, I thought that a single slot could hold two
rotational angles/points (at which a springs would start) and that that
the direction could be set so that both acting in the same direction with
different forces.
--
    Byte 2 - 0x_1
    Byte 3 - Clockwise angle, nominally on left (0x00..0xFF - 0x00 is
fully left)
    Byte 4 - Anti-Clockwise angle, nominally on right(0x00..0xFF)
    Byte 5 - L/R Proportion force, upper nibble clockwise + lower nibble
anti-clockwise (each 0x0..0xF)
    Byte 6 - Reverse Direction; upper nibble clockwise + lower nibble
anti-clockwise (each 0x0..0x1)
    Byte 7 - Force (0x00..0xFF)
--

Ie. turning from fully left (00) with no force, you could hit a 'weak'
spring (at 40) and then a 'stronger' spring (at 80).

So to some degree you /can/ merge springs... but I'm not saying that you
should :-).
Simon

