Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360Ab3BLPLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:11:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761054Ab3BLPLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:11:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2][v2] ima: Support a mode to appraise signed files only
Date: Tue, 12 Feb 2013 10:10:58 -0500
Message-Id: <1360681860-29045-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

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

This patch series adds new option, appraise_type=imasig_optional to allow
appraisal to pass even if no signatures are present on the file. If
signatures are present, then it has to be valid digital signature,
otherwise appraisal will fail.

v2: Changed patches based on Mimi's feedback.

Thanks
Vivek

Vivek Goyal (2):
  ima: detect security xattrs not enabled
  ima: Allow appraisal of digitally signed files only

 Documentation/ABI/testing/ima_policy  |    2 +-
 security/integrity/ima/ima_appraise.c |   27 +++++++++++++++++++++++----
 security/integrity/ima/ima_policy.c   |    2 ++
 security/integrity/integrity.h        |    1 +
 4 files changed, 27 insertions(+), 5 deletions(-)

-- 
1.7.7.6

