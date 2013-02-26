Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797Ab3BZSXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:23:53 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50123 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750Ab3BZSXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:23:50 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 26 Feb 2013 12:23:48 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v6 00/12] hwmon: Driver for Nuvoton NCT6775F, NCT6776F, and NCT6779D
Date: Tue, 26 Feb 2013 10:23:28 -0800
Message-Id: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver will replace the w83627ehf driver for NCT6775F and NCT6776F,
and provides support for NCT6779D.

This is a resend for most of the series. Patch 04/12 was updated, and patch
12/12 was added.

The driver has been available as standalone driver (https://github.com/groeck/nct6775)
since March 2012. It has been available as Archlinux package since July 2012
(https://aur.archlinux.org/packages.php?ID=61127).
At least one inofficial Ubuntu/Debian build is available at Launchpad
(http://ppa.launchpad.net/foresto/extradrivers/ubuntu/dists/quantal/main/source/Sources).
A bug has been submitted in Debian against not having this driver upstream
(http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=699140).

So there is some interest to get the driver upstream, and it does have at least
some level of test coverage. The only missing detail is someone with the time
to review the code. Expanding the audience in the hope of finding one.

v6:
- Spelling fix
- Fix fan register initialization for chips with no fan divisor (NCT6776,
  NCT6779)
- Don't report VID if disabled (NCT6775, NCT6776) or not supported (NCT6779)

v5:
- Review fedback
  - Documentation fixes
  - Split patch into several parts to simplify review. 
  - Updated attribute names
- Improved support for thermal and speed cruise modes
- Dropped pwmX_interpolate (or pwmX_step_enable) since I could not get it
  to work on any of the chips.
- Added power management support
- Added support for fanX_pulses attribute
- Improved fan divider selection
- Removed unused defines
- 'valid' is now bool
- Removed __devinit/__devexit

v4:
- Fix "temp" array size (reported by smatch)
- Fix whitespace errors reported by "git am" (but not by checkpatch).
- Order register definition data by chip type
- Improve parameter alignment

v3:
- Variables pwm_temp, REG_TEMP_MON, and NCT6775_REG_TEMP_MON are not used,
  drop it.

v2:
- superio region access protection
- Add support for pwmX_step_enable attribute
- Improved documentation
