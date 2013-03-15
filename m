Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3COUgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:36:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab3COUgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:36:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@intel.com
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, vgoyal@redhat.com
Subject: [RFC PATCH 0/4] IMA: Export functions for file integrity verification
Date: Fri, 15 Mar 2013 16:35:54 -0400
Message-Id: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is just a proof of concept RFC to export some functions from IMA for
file integrity verification. And there is a patch which modified binfmt_elf.c
to show how a IMA subsystem user can call into IMA to verify integrity
of a file.

This patch set is far from being done. I am just throwing it out so that
we can start a discussion on whether exporting IMA functions makes sense
and if it does, then how those functions should look like.

Thanks
Vivek

Vivek Goyal (4):
  integrity: Identify asymmetric digital signature using new type
  ima: export new IMA functions for signature verification
  capability: Create a new capability CAP_SIGNED
  binfmt_elf: Elf executable signature verification

 fs/Kconfig.binfmt                     |   12 ++++++++
 fs/binfmt_elf.c                       |   44 +++++++++++++++++++++++++++++++
 include/linux/ima.h                   |   24 ++++++++++++++++-
 include/linux/integrity.h             |    7 +++++
 include/uapi/linux/capability.h       |   12 ++++++++-
 kernel/cred.c                         |    7 +++++
 security/commoncap.c                  |    2 +
 security/integrity/digsig.c           |   11 +++++---
 security/integrity/evm/evm_main.c     |    4 ++-
 security/integrity/ima/ima_api.c      |   16 +++++++++++
 security/integrity/ima/ima_appraise.c |   46 +++++++++++++++++++++++++++++++-
 security/integrity/integrity.h        |   14 +++------
 12 files changed, 181 insertions(+), 18 deletions(-)

-- 
1.7.7.6

