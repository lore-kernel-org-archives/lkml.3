Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966171Ab3HHSuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:50:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42666 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966070Ab3HHSut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:50:49 -0400
Message-ID: <1375987848.2424.163.camel@joe-AO722>
Subject: Re: Review [2/2] Staging: BCM: Removed more whitespace/Errors
From: Joe Perches <joe@perches.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: gregkh@linuxfoundation.org, Linux-Devel <devel@driverdev.osuosl.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 08 Aug 2013 11:50:48 -0700
In-Reply-To: <5203D6E4.9080201@gmail.com>
References: <5203D6E4.9080201@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 18:35 +0100, Paul McQuade wrote:
>  From 9f6231ce16996e35545e20ce1d91abc058f2a6fb Mon Sep 17 00:00:00 2001
> From: Paul McQuade <paulmcquad@gmail.com>
> Date: Thu, 8 Aug 2013 17:49:22 +0100
> Subject: [PATCH 2/2] Staging: BCM: Removed more whitespace/Errors
> 
> Interface Whitespace/Errors Removed with the help of checkpatch.pl

Hey Paul.

A suggestion for you:

Use the latest version of -next.
Apply this patch: https://patchwork.kernel.org/patch/2839733/

Try this:

First convert the // comments to /* */ style

$ ./scripts/checkpatch.pl --strict -f --types=c99_comments --fix drivers/staging/bcm/*.[ch]
$ find drivers/staging/bcm/ -name "*.EXPERIMENTAL-checkpatch-fixes" | \
  while read file ; do mv $file ${file%.EXPERIMENTAL-checkpatch-fixes}; done

Commit this to a new git branch and then do

$ ./scripts/checkpatch.pl --strict -f --types=spacing --fix drivers/staging/bcm/*.[ch]
$ find drivers/staging/bcm/ -name "*.EXPERIMENTAL-checkpatch-fixes" | \
  while read file ; do mv $file ${file%.EXPERIMENTAL-checkpatch-fixes}; done

This produces a pretty big diff

$ git diff --stat drivers/staging
 drivers/staging/bcm/Adapter.h           |    2 +-
 drivers/staging/bcm/Bcmchar.c           |   24 +-
 drivers/staging/bcm/Bcmnet.c            |    2 +-
 drivers/staging/bcm/DDRInit.c           | 1576 +++++++++++++++---------------
 drivers/staging/bcm/IPv6Protocol.c      |    4 +-
 drivers/staging/bcm/InterfaceIdleMode.c |   26 +-
 drivers/staging/bcm/InterfaceInit.c     |   12 +-
 drivers/staging/bcm/InterfaceIsr.c      |   82 +-
 drivers/staging/bcm/InterfaceMisc.h     |    4 +-
 drivers/staging/bcm/InterfaceRx.c       |  102 +-
 drivers/staging/bcm/InterfaceTx.c       |   84 +-
 drivers/staging/bcm/PHSModule.c         |    2 +-
 drivers/staging/bcm/PHSModule.h         |   14 +-
 drivers/staging/bcm/Prototypes.h        |   48 +-
 drivers/staging/bcm/Qos.c               |    4 +-
 drivers/staging/bcm/Queue.h             |   10 +-
 drivers/staging/bcm/Transmit.c          |    4 +-
 drivers/staging/bcm/hostmibs.c          |   10 +-
 drivers/staging/bcm/nvm.c               |   12 +-
 19 files changed, 1011 insertions(+), 1011 deletions(-)

You could investigate the differences here and
determine what you want to do with them.

The biggest diff is in DDRIinit.c.

Most all of these changes are space additions after comma.

Here's an example:

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 1d19484..e8900c1 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -7,527 +7,527 @@
 
     /* DDR INIT-133Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3_DDRSetting133MHz[]= {/* # DPLL Clock Setting */
-                                        {0x0F000800,0x00007212},
-                                        {0x0f000820,0x07F13FFF},
-                                        {0x0f000810,0x00000F95},
-                                        {0x0f000860,0x00000000},
-                                        {0x0f000880,0x000003DD},
+static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {/* # DPLL Clock Setting */
+                                        {0x0F000800, 0x00007212},
+                                        {0x0f000820, 0x07F13FFF},
+                                        {0x0f000810, 0x00000F95},
+                                        {0x0f000860, 0x00000000},
+                                        {0x0f000880, 0x000003DD},


These are all poor style.
These should actually look like:

+static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {/* # DPLL Clock Setting */
+	{0x0F000800, 0x00007212},
+	{0x0f000820, 0x07F13FFF},
+	{0x0f000810, 0x00000F95},
+	{0x0f000860, 0x00000000},
+	{0x0f000880, 0x000003DD},

the --fix option won't do that.
You'll have to do that by hand.

Maybe just do a git checkout drivers/staging/bcm/DDRIinit.c
before committing the other changes.

