Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3FJJ3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:29:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35894 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab3FJJ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:29:09 -0400
Date: Mon, 10 Jun 2013 11:29:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130610092907.GA5487@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>From start of 3.10-rc series, bluetooth seems to be gone on thinkpad
x60.

root@amd:~# uname -a
Linux amd 3.10.0-rc5+ #261 SMP Mon Jun 10 02:59:55 CEST 2013 i686
GNU/Linux

pavel@amd:~$ lsusb 
Bus 005 Device 003: ID 0483:2016 SGS Thomson Microelectronics
Fingerprint Reader
Bus 005 Device 002: ID 0a5c:2110 Broadcom Corp. Bluetooth Controller
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 007: ID 046d:c05a Logitech, Inc. Optical Mouse M90
Bus 001 Device 006: ID 04f2:0111 Chicony Electronics Co., Ltd KU-9908
Keyboard
Bus 001 Device 003: ID 17ef:1000 Lenovo 
Bus 001 Device 002: ID 0421:01c7 Nokia Mobile Phones N900 (Storage
Mode)
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

root@amd:~# hciconfig hci0 up
Can't init device hci0: Operation not supported (95)
root@amd:~# hcitool inq
Inquiring ...
Inquiry failed.: No such device
root@amd:~# 

(This is regression from 3.9.)

dmesg does not show much:

thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
thinkpad_acpi: warning: userspace override of important firmware LEDs
is enabled
thinkpad_acpi: Standard ACPI backlight interface available, not
loading native one
thinkpad_acpi: volume: disabled as there is no ALSA support in this
kernel

Bluetooth LED is on (and wifi works), so it is not hardware kill
switch.


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
