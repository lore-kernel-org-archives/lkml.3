Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbaE2ItE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:49:04 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50580 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbaE2ItA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:49:00 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-serial@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Jiri Slaby <jslaby@suse.cz>,
        Dirk Behme <dirk.behme@de.bosch.com>
Subject: [PATCH tty-next v2 0/4] serial: kgdb_nmi: Allow ttyNMIX to act as primary console
Date: Thu, 29 May 2014 09:48:42 +0100
Message-Id: <1401353326-14148-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140528200344.GA2750@kroah.com>
References: <20140528200344.GA2750@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains a number of fixes to make it possible to use
ttyNMIX as the primary console (providing you also have that the
additional architecture specific code which is proposed in a 
different patch set).

The first patch fixes a bug in the cpm poll_put_char() driver. This
is not strictly related to ttyNMIX but appears in this patch series
for historical reasons (it was part of a patch that did impact ttyNMIX
but most of that patch is already in the kernel thanks to an 
independent patch from Doug Anderson).

The remaining patches are specific to kgdb_nmi and have no effect on
any other part of the kernel.

The series has been runtime tested on ARM and compile tested on
x86 and powerpc.

Changes since v1:

- Trimmed down the first patch to the remaining fragments as described 
  above.
- Rebased on tty-next as requested by Greg KH.

Daniel Thompson (4):
  serial: cpm_uart: No LF conversion in put_poll_char()
  serial: kgdb_nmi: Use container_of() to locate private data
  serial: kgdb_nmi: Switch from tasklets to real timers
  serial: kgdb_nmi: Improve console integration with KDB I/O

 drivers/tty/serial/cpm_uart/cpm_uart_core.c |  8 ++--
 drivers/tty/serial/kgdb_nmi.c               | 59 +++++++++++++----------------
 2 files changed, 31 insertions(+), 36 deletions(-)

-- 
1.9.0

