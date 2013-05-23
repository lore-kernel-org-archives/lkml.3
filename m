Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3EWN7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:59:43 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:43858 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759175Ab3EWN7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:59:41 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org
Subject: [PATCH v3 part3 0/7] Customize the SG_IO whitelist for different device classes
Date: Thu, 23 May 2013 15:59:28 +0200
Message-Id: <1369317575-4236-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last problem in the SG_IO whitelist is that because the bitmap
of allowed commands is designed for MMC devices only, some commands
are missing even though they are generally useful and not insecure.
At least, they are not more insecure than anything else you can do
if you have access to /dev/sdX or /dev/stX nodes.

In particular, the whitelist is hardly usable for tapes; and in the
case of virtualization, the few missing commands for disks may cause
guests to log errors.

Paolo

Paolo Bonzini (7):
  sg_io: complete transition to per-class lists of allowed commands
  sg_io: create separate entries for conflicting commands
  sg_io: cleanup and complete whitelist for rare device types
  sg_io: whitelist another command for multimedia devices
  sg_io: cleanup and complete whitelist for media changers
  sg_io: cleanup and complete whitelist for tapes
  sg_io: cleanup and complete whitelist for disks

 block/scsi_ioctl.c  | 309 ++++++++++++++++++++++++++++++++++------------------
 include/scsi/scsi.h |   3 +
 2 files changed, 206 insertions(+), 106 deletions(-)

-- 
1.8.1.4

