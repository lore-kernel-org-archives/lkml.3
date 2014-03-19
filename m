Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaCSUAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:00:11 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59873 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbaCSUAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:00:08 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 0/5] efivars compat support
Date: Wed, 19 Mar 2014 19:59:55 +0000
Message-Id: <1395259200-27732-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Apparently people are running 32-bit userland on top of 64-bit kernels
and wanting to interact with efivars. At the moment this doesn't work
all too well because 'struct efi_variable' (the data blob passed between
userland and kernel) contains unsigned long data items, leading to
incompatibilities and tears.

We can fix this up fairly trivially in the kernel by using
is_compat_task() and doing a small amount of data munging.

Matt Fleming (5):
  efivars: Use local variables instead of a pointer dereference
  efivars: Check size of user object
  efivars: Stop passing a struct argument to efivar_validate()
  efivars: Refactor sanity checking code into separate function
  efivars: Add compatibility code for compat tasks

 drivers/firmware/efi/efivars.c | 192 ++++++++++++++++++++++++++++++++++-------
 drivers/firmware/efi/vars.c    |  30 +++----
 include/linux/efi.h            |   6 +-
 3 files changed, 181 insertions(+), 47 deletions(-)

-- 
1.8.5.3

