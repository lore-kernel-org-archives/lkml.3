Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbbA1UqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:46:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbbA1UqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:46:20 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add device_create_files() and device_remove_files() helpers
Date: Wed, 28 Jan 2015 21:46:12 +0100
Message-Id: <1422477974-8369-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a simple patch to add device_create_files() and
device_remove_files() to replace multiple device_create_file() or
_remove() calls with a single shot with the device_attr list.

It's basically just a clean up, but also helps to simplify the error
handling a lot in many existing codes since the function itself does
rollback at error.

The series contains a patch to apply these to drivers/base/node.c.
I have lots of patches (up to 30) to use these in the whole tree, but
maybe it'd be easier too apply once after this stuff is merged at
first.  It's just a cleanup so no urgent task, after all.


thanks,

Takashi

===

Takashi Iwai (2):
  driver core: Add device_create_files() and device_remove_files()
    helpers
  drivers/base/node: Use device_create_files() and device_remove_files()

 drivers/base/core.c    | 36 ++++++++++++++++++++++++++++++++++++
 drivers/base/node.c    | 24 ++++++++++++------------
 include/linux/device.h |  4 ++++
 3 files changed, 52 insertions(+), 12 deletions(-)

-- 
2.2.2

