Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3KDDjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:39:35 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:42154 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab3KDDi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:38:58 -0500
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>
Subject: tpm: Remainder of earlier clean up
Date: Sun,  3 Nov 2013 20:38:41 -0700
Message-Id: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the last five patches from the prior series I sent that didn't get
picked up yet.

There are no changes, these are just rebased onto 3.12rc7 + Peter's for-james
branch. (Peter: Note, there are TPM changes to the Xen driver in 3.12rc7 that
are not in your for-james branch)

The intent of these patches is to reduce the duplicated code that is present
in all the drivers by migrating it into the core.

I've placed the patches on my github:
 https://github.com/jgunthorpe/linux/commits/for-tpm

 drivers/char/tpm/Makefile           |    2 +-
 drivers/char/tpm/tpm-dev.c          |  213 +++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-interface.c    |  487 +++++-------------------------------------------------------------------------------
 drivers/char/tpm/tpm-sysfs.c        |  318 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.h              |   83 +++++++--------
 drivers/char/tpm/tpm_atmel.c        |   28 +----
 drivers/char/tpm/tpm_i2c_atmel.c    |   42 +-------
 drivers/char/tpm/tpm_i2c_infineon.c |   42 +-------
 drivers/char/tpm/tpm_i2c_nuvoton.c  |   42 +-------
 drivers/char/tpm/tpm_i2c_stm_st33.c |   41 +------
 drivers/char/tpm/tpm_ibmvtpm.c      |   40 +------
 drivers/char/tpm/tpm_infineon.c     |   28 +----
 drivers/char/tpm/tpm_nsc.c          |   28 +----
 drivers/char/tpm/tpm_tis.c          |   49 +--------
 drivers/char/tpm/xen-tpmfront.c     |   45 +-------
 include/linux/tpm.h                 |   12 +++
 16 files changed, 624 insertions(+), 876 deletions(-)

