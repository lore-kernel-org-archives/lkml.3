Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3HXPHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 11:07:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59364 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839Ab3HXPHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 11:07:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI fix for v3.11-rc7
Date: Sat, 24 Aug 2013 17:17:56 +0200
Message-ID: <11694750.y7arDE0Ss8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git acpi-3.11-rc7

to receive one ACPI fix for v3.11-rc7 as
commit 168cf0eca45b86014b8c2a17fcb0673ab1af809b

  Revert "ACPI / video: Always call acpi_video_init_brightness() on init"

on top of commit b36f4be3de1b123d8601de062e7dbfc904f305fb

  Linux 3.11-rc6

I really hoped that it wouldn't be necessary to change anything in ACPI at
this point, but it turns out that we need to revert one more ACPI video
commit causing trouble.

This reverts a change in the ACPI video driver that caused the ACPI
backlight initialization to be carried out even if acpi_backlight=vendor
is passed in the kernel command line which turns out to break things
at least on one system.

Thanks!


---------------

Rafael J. Wysocki (1):
      Revert "ACPI / video: Always call acpi_video_init_brightness() on init"

---------------

 drivers/acpi/video.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

