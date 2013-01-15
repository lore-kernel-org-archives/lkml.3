Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3AOUgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:36:10 -0500
Received: from mga07.intel.com ([143.182.124.22]:24401 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753305Ab3AOUgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:36:07 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        akpm@linux-foundation.org, alan.cox@intel.com, mbroz@redhat.com,
        mpatocka@redhat.com
Subject: [PATCH v2.1 0/1] dm-integrity: integrity protection device-mapper target
Date: Tue, 15 Jan 2013 22:35:56 +0200
Message-Id: <cover.1358282111.git.dmitry.kasatkin@intel.com>
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

I addressed all comments I got so far. Can it be now added to the DM tree?

- Dmitry

Dmitry Kasatkin (1):
  dm-integrity: integrity protection device-mapper target

 Documentation/device-mapper/dm-integrity.txt |  137 ++++
 drivers/md/Kconfig                           |   13 +
 drivers/md/Makefile                          |    1 +
 drivers/md/dm-integrity.c                    | 1051 ++++++++++++++++++++++++++
 4 files changed, 1202 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-integrity.txt
 create mode 100644 drivers/md/dm-integrity.c

-- 
1.7.10.4

