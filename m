Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab3CFNiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:38:54 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:50318 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab3CFNiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:38:51 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 0/7] n_tty fixes
Date: Wed,  6 Mar 2013 08:38:18 -0500
Message-Id: <1362577105-19757-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series combines a number of fixes for the N_TTY
line discipline.

These address unsafe use of the foreground process group id:
  n_tty: Fix unsafe driver-side signals
  n_tty: Lock access to tty->pgrp for POSIX job control

These continue Jiri's work to separate ldisc from tty:
  tty: Fix checkpatch errors in tty_ldisc.h
  n_tty: Encapsulate minimum_to_wake within N_TTY

The rest are self-explanatory:
  n_tty: Untangle read completion variables
  n_tty: Fix unsafe update of available buffer space
  n_tty: Buffer work should not reschedule itself


Peter Hurley (7):
  n_tty: Fix unsafe driver-side signals
  n_tty: Lock access to tty->pgrp for POSIX job control
  tty: Fix checkpatch errors in tty_ldisc.h
  n_tty: Encapsulate minimum_to_wake within N_TTY
  n_tty: Untangle read completion variables
  n_tty: Fix unsafe update of available buffer space
  n_tty: Buffer work should not reschedule itself

 drivers/tty/n_tty.c       | 144 +++++++++++++++++++++++++---------------------
 drivers/tty/tty_io.c      |  17 +++---
 include/linux/tty.h       |   1 -
 include/linux/tty_ldisc.h | 138 +++++++++++++++++++++++---------------------
 4 files changed, 161 insertions(+), 139 deletions(-)

-- 
1.8.1.2

