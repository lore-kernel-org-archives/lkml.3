Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaFLURl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:17:41 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:55654 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaFLURk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:17:40 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Google-Original-From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jwboyer@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1a 0/2] KEYS: validate key trust with owner and builtin keys only
Date: Thu, 12 Jun 2014 23:17:09 +0300
Message-Id: <cover.1402604096.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a repost of the patchset cleanly on the top of linux-integrity
next-trusted-keys branch.

Instead of allowing public keys, with certificates signed by any key on
the system trusted keyring, to be added to a trusted keyring, this patch
set further restricts the certificates to those signed by a particular key
or builtin keys on the system keyring.

This patch defines a new kernel parameter 'keys_ownerid={id:xxx | builtin}'
to use specific key or any builtin key.

Thanks,
Dmitry

Dmitry Kasatkin (2):
  KEYS: validate certificate trust only with selected owner key
  KEYS: validate certificate trust only with builtin keys

 Documentation/kernel-parameters.txt      |  5 +++++
 crypto/asymmetric_keys/x509_public_key.c | 32 ++++++++++++++++++++++++++++++--
 include/linux/key.h                      |  1 +
 kernel/system_keyring.c                  |  1 +
 4 files changed, 37 insertions(+), 2 deletions(-)

-- 
1.9.1

