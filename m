Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaKFXyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:54:35 -0500
Received: from mout.web.de ([212.227.15.4]:50640 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaKFXyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 18:54:33 -0500
MIME-Version: 1.0
Message-ID: <trinity-0270e0ae-a135-4789-9ed2-f8fd1f7cff71-1415318071046@3capp-webde-bs13>
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: rafael.j.wysocki@intel.com
Subject: dmesg spam: "PnPBIOS: pnp_dock_thread: unexpected status 0x5
 flooding"
Content-Type: text/plain; charset=UTF-8
Date: Fri, 7 Nov 2014 00:54:31 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K0:a1ASsgL3VmQYt1pRn6J/hNUEAi0fBwAyyA6D9ZHdkUJ
 B3/UG4Eo+NQ5LJ2u04q3O43rcvi7dWp0XsKjv/zRt1GySOJTsY
 Jr6KvsZ1xTBoQkPTwql06wmoA3QEZJA/XgF3bSw2ExsbwVls8G
 xzHI9mapMFnD+ptieamqi2pM/NDdkM9J+PK3PDE8eiRdZz/CnU
 hx1hI+SopVZUk2aPepZhzfV3Il9ucWSovAs+LW6UCPWs8HPYxE
 eSbJsRdq2Y8yj9TVNC3t6fKnTYSZhJxL6Qx1CrszwUh91o/2uT
 SIZUqLoJ4qDVpzbBgHqU7XxXt7/
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

on an ancient GX1 Geode embedded board (Evo T20/Wyse wt3235le Thin Client, which are cheap (<$10) and low power x86 embeded platform) , dmesg is getting constantly spammed with "PnPBIOS: pnp_dock_thread: unexpected status 0x5" during and after boot. 

Any ideas what this means and how to stop that?

It seems it comes from drivers/pnp/pnpbios/bioscalls.c -> pnpbios_print_status()  

Tried adding pnpbios=off, but with that the system does not boot anymore.

Being curious, why a non-existing docking-station is being "polled at regular intervals" (i.e. every 2 seconds - see drivers/pnp/pnpbios/core.c )

>From http://books.google.de/books?id=ibLa4I5EnC4C&pg=PA231&lpg=PA231&dq=pnp+docking+bios&source=bl&ots=ekCFm34U_B&sig=9Z9L55IAL7_3NtuM10jT3serncM&hl=de&sa=X&ei=mAZcVILnJsviO-r5gNgI&ved=0CCsQ6AEwAQ#v=onepage&q=pnp%20docking%20bios&f=false   i read:  "Function 05h - Get Docking Status Information at page 251" 

it  seems this is being the result of a "docking event" ? Does this mean, my system is erroneusly generating such docking events, even if there is no docking station at all?

regards
roland

ps:
i`m booting via plopKexec Bootloader ( http://www.plop.at/de/plopkexec.html ) , as i can put kernel+rootfs on external usb and don`t need to reflash the device, which is complicated task.

pps:
some few old pointers from other people reporting it:
https://lists.debian.org/debian-kernel/2005/02/msg00238.html
http://sourceforge.net/p/open-evot20/mailman/message/20065770/
