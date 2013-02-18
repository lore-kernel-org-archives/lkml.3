Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab3BREnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 23:43:50 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38385 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab3BREnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 23:43:49 -0500
MIME-Version: 1.0
Date: Sun, 17 Feb 2013 20:43:47 -0800
X-Google-Sender-Auth: pMMQuFbnPAir7WsphliKknykifc
Message-ID: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
Subject: i915 black screen introduced by ACPI changes
From: Chris Li <lkml@chrisli.org>
To: linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, robert.moore@intel.com, feng.tang@intel.com,
        len.brown@intel.com, daniel.vetter@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Lenovo Y580 laptop with FC18 start to get black screen after the kernel
upgrade to 3.7.xxx

The black screen happens about the time kernel switch to using VT console.
At the point of black screen, no response of cap locks key led no network
connection. The machine seems dead.

The CPU is i7 and it has two video card. The Intel build-in video card
and Gtx 660M Nvidia card.

This is very annoying. I did some poking around it:
- It was fine on the FC18 3.6.xxx kernel before the upgrade.
- The black screen exists with FC18 3.7.xxx kernel
- The black screen also exists in latest tip of linux-2.6.
- Switch to multi-user mode booting does not get rid of the black screen.
- Get rid of the "rhrb quit" does not help either.
- When the black screen happen, cap lock LED does not response to cap locks.
- No networking when black screen happen. The only thing to do is
reboot the system.
- Adding "i915.modeset=0" will allow the kernel to boot into GUI login. However,
  logout of X will cause the machine to hang similar to the black screen.
- Suspend and resume will get stuck at the black screen with"i915.modeset=0".
- Kernel console and X is using the Intel driver for display.

There are other user experience the same problem as well.
http://forums.fedoraforum.org/showthread.php?t=287853

The black screen is introduced between v3.6 and v3.7. I did the git bisect.
It points to this ACPI change which is a little bit surprising. I was
expecting some
change relate to i915 driver. I double check commit before this does
not have black
screen.

Anyway, any suggestion to nail down this problem?
I am happy to reproduce and verify the fix.

Thanks

Chris


commit a57f7f9175b8ccbc9df83ac13860488913115de4
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Aug 17 10:55:02 2012 +0800

    ACPICA: Add Windows8/Server2012 string for _OSI method.

    This change adds a new _OSI string, "Windows 2012" for both Windows 8
    and Windows Server 2012.

    From Microsoft document "How to Identify the Windows Version in ACPI
    by Using _OSI", July 13, 2012.

    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
