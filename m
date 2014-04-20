Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaDTSFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 14:05:51 -0400
Received: from host171.canaca.com ([67.55.55.225]:47383 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaDTSFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 14:05:49 -0400
X-Greylist: delayed 2324 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2014 14:05:49 EDT
Message-ID: <c49c4ad2bfabfe75ac065f8ad878d697.squirrel@mungewell.org>
In-Reply-To: <1609685.QRL9N9sQvX@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
Date: Sun, 20 Apr 2014 13:27:01 -0400
Subject: Re: [PATCH 0/24] Introduce ff-memless-next as an improved
 replacement for ff-memless
From: simon@mungewell.org
To: =?iso-8859-1?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Elias Vanderstuyft" <elias.vds@gmail.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20140420132701_71282"
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

------=_20140420132701_71282
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

> ff-memless-next (MLNX) is a largely improved version of the current
> ff-memless
> (FFML) driver. MLNX supports all force feedback effects currently
> available in
> the Linux force feedback userspace API. All effects are handled in
> accordance
> with Microsoft's DirectInput/XInput.

Hi all,
I got a chance to build this series of patches and test with the
controllers I have (*). Without specific instructions I wasn't sure
exactly what to test, but it seems to be OK and the devices
rumbled/wobbled appropriately,
Simon

tested-by: Simon Wood <simon@mungewell.org>

* controllers:
hid-sony: DS4, DS3SA, Intec
hid-lg: WiiWheel, MomoRed, MomoBlack, DFP, WingMan Force
------=_20140420132701_71282
Content-Type: text/plain; name="ff-memles.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="ff-memles.txt"

just testing that fftest does something:
DS4 = ok
DS3-SA = ok
Intec (3rd party PS3 cotroller) = ok


Logitech Wingman Force 3D
Bus 005 Device 009: ID 046d:c283 Logitech, Inc. WingMan Force 3D
--
simon@slipstream:~$ fftest /dev/input/event8
Force feedback test program.
HOLD FIRMLY YOUR WHEEL OR JOYSTICK TO PREVENT DAMAGES

Device /dev/input/event8 opened
Features:
  * Absolute axes: X, Y, RZ, Throttle, Hat 0 X, Hat 0 Y, 
    [63 00 03 00 00 00 00 00 ]
  * Relative axes: 
    [00 00 ]
  * Force feedback effects types: Constant, Periodic, Ramp, Rumble, Gain, 
    Force feedback periodic effects: Square, Triangle, Sine, Saw up, Saw down, 
    [00 00 00 00 00 00 00 00 00 00 87 1F 01 00 00 00 ]
  * Number of simultaneous effects: 16

Setting master gain to 75% ... OK
Uploading effect #0 (Periodic sinusoidal) ... OK (id 0)
Uploading effect #1 (Constant) ... OK (id 1)
Uploading effect #2 (Spring) ... Error: Invalid argument
Uploading effect #3 (Damper) ... Error: Invalid argument
Uploading effect #4 (Strong rumble, with heavy motor) ... OK (id 2)
Uploading effect #5 (Weak rumble, with light motor) ... OK (id 3)
Enter effect number, -1 to exit
--
0 - something, but not sine. hard to back/right after effect ends
1 - hard forward/center, then back/right after effect
4 - slow back <-> forward, then back/right after effect
5 - fast back <-> forward, ""
--
simon@slipstream:~$ ffset -a 100 /dev/input/event8 [no force]
Device /dev/input/event8 opened
simon@slipstream:~$ ffset -a 0 /dev/input/event8 [no force]
Device /dev/input/event8 opened
--

Logitech Wii Wheel
Bus 005 Device 006: ID 046d:c29c Logitech, Inc. Speed Force Wireless Wheel for Wii
--
simon@slipstream:~$ fftest /dev/input/event8
Force feedback test program.
HOLD FIRMLY YOUR WHEEL OR JOYSTICK TO PREVENT DAMAGES

Device /dev/input/event8 opened
Features:
  * Absolute axes: X, Y, Z, 
    [07 00 00 00 00 00 00 00 ]
  * Relative axes: 
    [00 00 ]
  * Force feedback effects types: Constant, Periodic, Ramp, Rumble, Gain, Autocenter, 
    Force feedback periodic effects: Square, Triangle, Sine, Saw up, Saw down, 
    [00 00 00 00 00 00 00 00 00 00 87 1F 03 00 00 00 ]
  * Number of simultaneous effects: 16

Setting master gain to 75% ... OK
Uploading effect #0 (Periodic sinusoidal) ... OK (id 0)
Uploading effect #1 (Constant) ... OK (id 1)
Uploading effect #2 (Spring) ... Error: Invalid argument
Uploading effect #3 (Damper) ... Error: Invalid argument
Uploading effect #4 (Strong rumble, with heavy motor) ... OK (id 2)
Uploading effect #5 (Weak rumble, with light motor) ... OK (id 3)
Enter effect number, -1 to exit
--
0 - wobble
1 - nothing?
4 - slow wobble
5 - fast wobble
--
simon@slipstream:~$ ffset -a 100 /dev/input/event8 [ok]
Device /dev/input/event8 opened
simon@slipstream:~$ ffset -g 10 /dev/input/event8 [ok]
Device /dev/input/event8 opened
simon@slipstream:~$ ffcfstress -d /dev/input/event8 [ok]
--


Logitech Momo-Red
Bus 005 Device 010: ID 046d:c295 Logitech, Inc. Momo Force Steering Wheel
--
simon@slipstream:~$ fftest /dev/input/event8
Force feedback test program.
HOLD FIRMLY YOUR WHEEL OR JOYSTICK TO PREVENT DAMAGES

Device /dev/input/event8 opened
Features:
  * Absolute axes: X, Y, Z, 
    [07 00 00 00 00 00 00 00 ]
  * Relative axes: 
    [00 00 ]
  * Force feedback effects types: Constant, Periodic, Ramp, Rumble, Gain, Autocenter, 
    Force feedback periodic effects: Square, Triangle, Sine, Saw up, Saw down, 
    [00 00 00 00 00 00 00 00 00 00 87 1F 03 00 00 00 ]
  * Number of simultaneous effects: 16

Setting master gain to 75% ... OK
Uploading effect #0 (Periodic sinusoidal) ... OK (id 0)
Uploading effect #1 (Constant) ... OK (id 1)
Uploading effect #2 (Spring) ... Error: Invalid argument
Uploading effect #3 (Damper) ... Error: Invalid argument
Uploading effect #4 (Strong rumble, with heavy motor) ... OK (id 2)
Uploading effect #5 (Weak rumble, with light motor) ... OK (id 3)
Enter effect number, -1 to exit
--
0 - slow wobble
1 - very weak CF to left
2 - nothing
3 - nothing
4 - slow wobble
5 - fast wobble
--
simon@slipstream:~$ ffset -a 100 /dev/input/event8	[ok]
Device /dev/input/event8 opened
simon@slipstream:~$ ffset -a 0 /dev/input/event8	[ok]
Device /dev/input/event8 opened
simon@slipstream:~$ ffset -g 100 /dev/input/event8	[ok]
Device /dev/input/event8 opened
--

Logitech Momo-Black
Bus 005 Device 004: ID 046d:ca03 Logitech, Inc. MOMO Racing
--
mon@slipstream:~$ fftest /dev/input/event8
Force feedback test program.
HOLD FIRMLY YOUR WHEEL OR JOYSTICK TO PREVENT DAMAGES

Device /dev/input/event8 opened
Features:
  * Absolute axes: X, Y, Z, 
    [07 00 00 00 00 00 00 00 ]
  * Relative axes: 
    [00 00 ]
  * Force feedback effects types: Constant, Periodic, Ramp, Rumble, Gain, Autocenter, 
    Force feedback periodic effects: Square, Triangle, Sine, Saw up, Saw down, 
    [00 00 00 00 00 00 00 00 00 00 87 1F 03 00 00 00 ]
  * Number of simultaneous effects: 16

Setting master gain to 75% ... OK
Uploading effect #0 (Periodic sinusoidal) ... OK (id 0)
Uploading effect #1 (Constant) ... OK (id 1)
Uploading effect #2 (Spring) ... Error: Invalid argument
Uploading effect #3 (Damper) ... Error: Invalid argument
Uploading effect #4 (Strong rumble, with heavy motor) ... OK (id 2)
Uploading effect #5 (Weak rumble, with light motor) ... OK (id 3)
Enter effect number, -1 to exit
--
0 - slow wobble
1 - very weak CF to left
2 - nothing
3 - nothing
4 - slow wobble
5 - fast wobble
--
simon@slipstream:~$ ffset -a 100 /dev/input/event8	[ok]
Device /dev/input/event8 opened
simon@slipstream:~$ ffset -a 0 /dev/input/event8	[ok]
Device /dev/input/event8 opened
simon@slipstream:~$ ffset -g 100 /dev/input/event8	[ok]
Device /dev/input/event8 opened
--

Logitech DFP
Bus 005 Device 006: ID 046d:c298 Logitech, Inc. Driving Force Pro
--
simon@slipstream:~$ fftest /dev/input/event8
Force feedback test program.
HOLD FIRMLY YOUR WHEEL OR JOYSTICK TO PREVENT DAMAGES

Device /dev/input/event8 opened
Features:
  * Absolute axes: X, Y, RZ, Hat 0 X, Hat 0 Y, 
    [23 00 03 00 00 00 00 00 ]
  * Relative axes: 
    [00 00 ]
  * Force feedback effects types: Constant, Periodic, Ramp, Rumble, Gain, Autocenter, 
    Force feedback periodic effects: Square, Triangle, Sine, Saw up, Saw down, 
    [00 00 00 00 00 00 00 00 00 00 87 1F 03 00 00 00 ]
  * Number of simultaneous effects: 16

Setting master gain to 75% ... OK
Uploading effect #0 (Periodic sinusoidal) ... OK (id 0)
Uploading effect #1 (Constant) ... OK (id 1)
Uploading effect #2 (Spring) ... Error: Invalid argument
Uploading effect #3 (Damper) ... Error: Invalid argument
Uploading effect #4 (Strong rumble, with heavy motor) ... OK (id 2)
Uploading effect #5 (Weak rumble, with light motor) ... OK (id 3)
Enter effect number, -1 to exit
--
0 - slow wobble
1 - very weak CF to left
2 - nothing
3 - nothing
4 - slow wobble
5 - fast wobble
--
simon@slipstream:~$ ffset -a 100 /dev/input/event8	[ok]
Device /dev/input/event8 opened
simon@slipstream:~$ ffset -a 0 /dev/input/event8	[ok]
Device /dev/input/event8 opened
simon@slipstream:~$ ffset -g 100 /dev/input/event8	[ok]
Device /dev/input/event8 opened
--
------=_20140420132701_71282--


