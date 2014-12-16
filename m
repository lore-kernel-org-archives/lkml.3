Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaLPTwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:52:33 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54505 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaLPTwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:52:32 -0500
From: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Subject: [PATCH 0/4] uio hotplug support
Date: Tue, 16 Dec 2014 11:52:20 -0800
Message-Id: <1418759544-2610-1-git-send-email-mandeep.sandhu@cyaninc.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the ability to hotunplug a uio device while file handles
are still open without crashing.

The "locking" for hotunplug support is implemented in
a generic library, that should be reusable to make this
kind of support easier to add in other pieces of the kernel.

I'm re-submitting this patch originally authored by Eric W. Biederman.

See: https://lkml.org/lkml/2010/9/20/21

I have made minor modifications for making it compile with the latest
kernel version (3.18.0-rc7+).

I have tested this patch on Greg's staging-next branch with a fake
hotplug driver that I wrote. The code for the fake hotplug driver is
available here:
https://github.com/mandeepsandhu/uio-hotplug-test

I would like to attribute the patch to Eric, as he's the original
author and can possibly be the maintainer for fs/libunload.c? I can
put my name in "Tested-by" if people are satisified with the fake
test program I wrote.

Mandeep Sandhu (4):
  staging: uio: Simplify the lifetime logic of struct uio_device.
  staging: uio: Remove unused uio_info mmap method.
  staging: libunload: A library to help remove open files
  staging: uio: Implement hotunplug support, using libunload

 drivers/uio/uio.c          | 305 ++++++++++++++++++++++++++++++++-------------
 fs/Makefile                |   2 +-
 fs/libunload.c             | 169 +++++++++++++++++++++++++
 include/linux/uio_driver.h |  16 +--
 include/linux/unload.h     |  35 ++++++
 5 files changed, 427 insertions(+), 100 deletions(-)
 create mode 100644 fs/libunload.c
 create mode 100644 include/linux/unload.h

-- 
1.9.1

