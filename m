Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaA1Q36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:29:58 -0500
Received: from mx.ungleich.ch ([77.109.138.221]:35489 "EHLO mx.ungleich.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbaA1Q34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:29:56 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jan 2014 11:29:56 EST
Date: Tue, 28 Jan 2014 17:19:49 +0100
From: Nico Schottelius <nico-linux-20140128@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-linux-20140128@schottelius.org>
Subject: Keycodes missing / wrong on Lenovo Yoga 2 Pro
Message-ID: <20140128161949.GI2902@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20140128@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: artist (Linux 3.12.7-2-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day kernel hackers,

when trying out which events are recognised by xev
to adjust my xbindkeysrc, I noticed that various keys
are incorrectly recognised on this machine:

    - mute button on the side returns "f", should be xf86audiomute

    - fn + f4 returns f4, should be "Lock" (if we have such a symbol)
    - fn + f5 returns f5, should be ? (has to arrows on it)
    - fn + f6 returns nothing, should be "toggletouchpad" (or whatever
      the name of it is)
      dmesg returns
      [93762.432649] atkbd serio0: Unknown key released (translated set
      2, code 0xbf on isa0060/serio0).
      [93762.432653] atkbd serio0: Use 'setkeycodes e03f <keycode>' to
      make it known.

    - fn + f8 returns tab, should be ?
    - fn + f10 returns Super_L and q, should be "Switchmonitor" 
    - fn + home returns pause (correct)
    - fn + end returns pause (is there a key for break?)

I am wondering how to fix those keys (xorg, kernel?).
I used 3.12.7 and X 1.15.0 for testing.

Other interesting keys:

    - fn + f9 turns of the screen (seems to be hardware wise)

Furthermore I am wondering if there is a sensible way to change
the event I get from the Windows Logo below the touchscreen (currently
reported as Super_L). It would be awesome to be able to able to
distinguish the key between the touchscreen and the windows key.
Also, the "key" below the touchscreen cannot be pressed and combined
with keys on the keyboard.

I have uploaded pictures of the keyboard at
    http://home.schottelius.org/~nico/lenovo_yoga_2_pro/

Cheers,

Nico

p.s.: Please cc me on reply.
pps: The kernel fonts are (almost) unreadable when booting this
     device - the 3200x1800 resolution is definitely requiring 
     another font.

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
