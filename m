Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbaD2P7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:59:09 -0400
Received: from host171.canaca.com ([67.55.55.225]:37371 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbaD2P7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:59:07 -0400
Message-ID: <996a1b32fb688eeafed959bd545d9301.squirrel@mungewell.org>
In-Reply-To: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
Date: Tue, 29 Apr 2014 11:59:02 -0400
Subject: Re: [PATCH v4 00/24] input: Introduce ff-memless-next as an improved
 replacement for ff-memless
From: simon@mungewell.org
To: =?iso-8859-1?Q?=22Michal_Mal=C3=BD=22?= 
	<madcatxster@devoid-pointer.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org,
        =?iso-8859-1?Q?=22Michal_Mal=C3=BD=22?= 
	<madcatxster@devoid-pointer.net>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

> This patch series:
> 1) Adds "ff-memless-next" module [1]
> 2) Ports all hardware-specific drivers to MLNX's API [2-23]
> 3) Removes FFML and replaces it with MLNX [24]
>
> Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
>
> v4:
>  - Add a summary of changes between MLNX and FFML to the last patch
>  - Remove a stale empty line in hid-sony.c
>  - Add "Tested-by: Elias Vanderstuyft <elias.vds@gmail.com>" to hid-lg4ff
> patch.
>
> v3:
>  - Rebase against latest linux-next. Fixes conflict in hid-sony.c and
>    max8997_haptic.c
>  - Updated documentation in ff-memless-next.h. The documentation now
> describes
>    parameters of the callback function and specifically mentions that
>    HW-specific drivers must not keep a reference to mlnx_effect_command
> struct
>    to which a pointer is passed in the callback function.
>  - Fix a minor brace inconsistency in hid-lgff
>  I believe that all concerns regarding v2 have been resolved as false
> alarms.
>
> v2:
>  - Add missing msecs to jiffies conversion in ff-memless-next
>  - lgff: Properly convert force on Y axis from MLNX to device range
>          Support periodic effects for "joystick_ac" device class
>  - lg3ff: Properly convert forces from MLNX to device range
>  - Very minor coding style issues fixed

Hi all,
I'd confirm that I build v2 and tested on a number of devices (1), and it
appears to work OK.

The only slight hiccup was with an older version (Xubuntu 12.10)
'ffcfstress' application which did not correctly detect the CF
capabilities of my gaming wheel(s). This is believed to be a fault with
the application not using correct bit-field testing and appears to have
been fixed on later versions (Xubuntu 13.10).

I also built v4, but have not yet had time/access to all the devices
(other than DS4) to test.

Cheers,
Simon

Tested-by: Simon Wood <simon@mungewell.org>

(1) Devices:
Logitech Momo Red, Momo Black, DFGT, WiiWheel, G27
Sony DS3-SA, DS4, Intec 3rd Party PS3 controller
Nintendo Wii Remote


