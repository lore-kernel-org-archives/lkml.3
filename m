Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934959Ab3BNT5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:57:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934894Ab3BNTzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:55:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com
Subject: [RFC PATCH 0/6][v3] ima: Support a mode to appraise signed files only
Date: Thu, 14 Feb 2013 14:55:39 -0500
Message-Id: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently ima appraises all the files as specified by the rule. So
if one wants to create a system where only few executables are
signed, that system will not work with IMA.

With secureboot, one needs to disable kexec so that unsigned kernels
can't be booted. To avoid this problem, it was proposed that sign
/sbin/kexec binary and if signatures are verified successfully, give
an special capability to the /sbin/kexec process. And in secureboot
mode processes with that special capability can invoke sys_kexec()
system call.

So there is a need for IMA to allow appraising only signed binaries.
Unsigned binaries will pass the appraisal too, but will not get the
special capability. (Capability patches for that are yet to be written).

This patch series adds new option, appraise_type=optional to allow
appraisal to pass even if no signatures are present on the file. If
signatures are present, then it has to be valid digital signature,
otherwise appraisal will fail.

v2: Changed patches based on Mimi's feedback.
v3: - Changed appraise_type=imasig_optional to appraise_type=optional
    - Introduced new error codes.

Thanks
Vivek

Vivek Goyal (6):
  ima: detect security xattrs not enabled
  ima: Return INTEGRITY_FAIL if digital signature can't be verified
  ima/evm: Differentiate between ima/evm nolabel return code
  ima: Introduce new integrity error code INTEGRITY_XATTR_NOTSUPP
  ima: Allow appraisal of digitally signed files only
  ima: With appraise_type=optional, audit log some messages as info

 Documentation/ABI/testing/ima_policy  |    2 +-
 include/linux/integrity.h             |    4 +++-
 security/integrity/evm/evm_main.c     |    2 +-
 security/integrity/ima/ima_appraise.c |   26 ++++++++++++++++++--------
 security/integrity/ima/ima_main.c     |   14 ++++++++++++--
 security/integrity/ima/ima_policy.c   |    2 ++
 security/integrity/integrity.h        |    1 +
 7 files changed, 38 insertions(+), 13 deletions(-)

-- 
1.7.7.6

