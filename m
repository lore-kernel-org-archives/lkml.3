Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3GaTjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:39:20 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:32999 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab3GaTjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:39:19 -0400
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: at24 eeprom bind doesn't stimulate udev
Message-Id: <90994FE8-4A04-481C-8333-BE02C700E327@gmail.com>
Date: Wed, 31 Jul 2013 15:39:16 -0400
To: open list <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a shot in the dark, since I don't know where to start digging

In a yocto (1.4, kernel 3.4.52), I designed a bunch of udev rules to set some
permissions for some sysfs attributes, namely /sys/class/gpio/*/value and
/sys/bus/i2c/devices/0-00xx/eeprom.

I match the sysfs attributes appearing using something like: ACTION=="add",
SUBSYSTEM=="i2c", KERNEL=="?-005[012]", WAIT_FOR="eeprom", RUN+="/bin/chmod 664
/sys%p/eeprom"

In this example driver "at24" is bound to 0-005x because of modalias
"i2c:24c128".

When I "udev monitor &" then "echo 0-0051 >
/sys/bus/i2c/devices/0-0051/driver/[un]bind", nothing is dumped from udev. I
tried invoking udevd in the console using --debug, same result.

I do see the result of the driver binding and unbinding from sysfs. A dmesg
trace also appears which comes from the at24's probe(), confirming the echo
command is actually doing something in the kernel. It's just udev doesn't seem
to pick anything up. If I [un]bind other i2c devices, I see many udev event fly
by.

Where should I start to find the cause?

Thanks in advance!