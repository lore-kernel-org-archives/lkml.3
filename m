Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965429Ab3HHNuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:50:24 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:42395
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965407Ab3HHNuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:50:20 -0400
Message-ID: <5203A21A.4060806@newflow.co.uk>
Date: Thu, 08 Aug 2013 14:50:18 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: ARM: AM335x: Reboot broken in 3.11
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebooting appears to have broken in 3.11 (at some point before rc1).

Here is the console output:-

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.11.0-rc1-00006-gf550793 (mpfj@mpfj-nanobone) (gcc version 4.6.3 (Buildroot 2013.02-dirty) ) #328 Thu Aug 8 14:36:16 BST 2013
...
Welcome to Buildroot
nanobone login: root
Password:
# reboot
#
[   23.867076] UBIFS: background thread "ubifs_bgt0_0" stops
The system is going down NOW!
Sent SIGTERM to all processes
Sent SIGKILL to all processes
Requesting system reboot
[   25.924496] reboot: Restarting system

... and at this point the CPU seems to just freeze.

In 3v10, the board would reboot correctly back into uboot, etc.

I've also noticed that some of the output LEDs light up dim when the kernel
is booting on, and they come on full brightness at the reboot "freeze" point.
There are 4 LEDs affected and they are all connected to UART transmit pins.

Before I start bisecting, does anyone have any ideas ?

Cheers
Mark J.
