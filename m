Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3AVMhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:37:13 -0500
Received: from mga05.intel.com ([192.55.52.89]:4672 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699Ab3AVMhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:37:09 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: dm-devel@redhat.com, mbroz@redhat.com, mpatocka@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, alan.cox@intel.com
Subject: [PATCH v3 0/1] dm-integrity: integrity protection device-mapper target
Date: Tue, 22 Jan 2013 14:36:59 +0200
Message-Id: <cover.1358857891.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device-mapper "integrity" target provides transparent cryptographic integrity
protection of underlying read-write block device using hash-based message
authentication codes (HMACs), which can be stored on the same or different
block device.

Target uses kernel keyring to obtain a secret key for using in cryptographic
operations. It uses encrypted key type. Kernel never exposes those keys in
plain form to user space. Encrypted keys are encrypted using master key,
which can be either user or trusted type. User key type allows to supply a key
from the user space and trusted key uses TPM.

Secret key is usually device specific and binds integrity data to the device.
Data blocks and corresponding HMACs cannot be copied over from other systems.

The key advantage over dm-verity is that the target supports read-write and
requires less hash calculation operations. The key advantage over dm-crypt
is that it does not require encryption when it is not desired by technical or
other reasons. HMAC calculation generally requires less resources than
encryption.

The main purpose of the dm-integrity is to provide read-write capable local
block data integrity protection without encryption.

Changes in v3:
- removed unused variables and macros
- made reboot notifier target specific
- removed io counter
- moved prefetch to the map function
- added missing ti->error messages
- replaced using of mempool with per bio data
- replaced loff_t with sector_t for sectors and blocks
- added new option 'zero_on_error' to return zeroed block instead of an error
  default behavior is to return an error
- improved error printing

-Dmitry

Dmitry Kasatkin (1):
  dm-integrity: integrity protection device-mapper target

 Documentation/device-mapper/dm-integrity.txt |  137 ++++
 drivers/md/Kconfig                           |   13 +
 drivers/md/Makefile                          |    1 +
 drivers/md/dm-integrity.c                    |  991 ++++++++++++++++++++++++++
 4 files changed, 1142 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-integrity.txt
 create mode 100644 drivers/md/dm-integrity.c

-- 
1.7.10.4

