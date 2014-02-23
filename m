Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaBWXcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:32:31 -0500
Received: from prifuk.spider.cz ([31.31.77.241]:41497 "EHLO prifuk.cz"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbaBWXc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:32:29 -0500
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, anssi.hannula@gmail.com, elias.vds@gmail.com,
        jkosina@suse.cz, simon@mungewell.org
Subject: [PATCH v2 0/4] Add ff-memless-next and make hid-lg4ff use it
Date: Mon, 24 Feb 2014 00:24:02 +0100
Message-ID: <1516865.M993BQAYe4@geidi-prime>
User-Agent: KMail/4.12.2 (Linux/3.13.5-1-ARCHMOD; KDE/4.12.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

this patch series is a result of my work to improve FFB support for memoryless
devices. ff-memless-next is an improvement over the currently available
ff-memless which is well suited for joypads but cannot handle more advanced
devices such as racing wheels properly. As I have explained in one of RFCs
regarding ff-memless-next, the extent of the changes makes implementing
ff-memless-next as a patch to ff-memless unfeasible. As of now there is a total
of 27 drivers using ff-memless (including lg4ff) - a lot of them joypads.
I do not have access to any FFB joypad at the moment so I cannot
implement the functionality required to handle joypads properly - namely FF_RUMBLE
and emulation of FF_PERIODIC through FF_RUMBLE.
The plan is to implement the missing functionality and replace ff-memless completely
in the future. 

Second part of this series ports lg4ff driver over to ff-memless-next.
The immediate benefit of this is support of all periodic effects and ramp effect.

v2 addresses a few issues that have not been noticed at the time v1 was
submitted. Specific fixes are mentioned in the respective patches.

Michal M.

 Michal Malý (4):
  INPUT: Add ff-memless-next module
  HID: Port hid-lg4ff to ff-memless-next
  HID: Add support for periodic effects in hid-lg4ff
  HID: Add support for ramp effect in hid-lg4ff

 Documentation/input/ff-memless-next.txt | 141 ++++++
 drivers/hid/Kconfig                     |   2 +-
 drivers/hid/hid-lg4ff.c                 |  93 ++--
 drivers/input/Kconfig                   |  11 +
 drivers/input/Makefile                  |   1 +
 drivers/input/ff-memless-next.c         | 789 ++++++++++++++++++++++++++++++++
 include/linux/input/ff-memless-next.h   |  32 ++
 7 files changed, 1033 insertions(+), 36 deletions(-)
--
 1.9.0

--
