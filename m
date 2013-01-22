Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3AVWIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:08:01 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40984 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab3AVWHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:07:53 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/4] ima: enforcing appraise type
Date: Tue, 22 Jan 2013 17:07:30 -0500
Message-Id: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012222-5806-0000-0000-00001E9CD0AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IMA-appraisal extension added local integrity validation and
enforcement of the measurement against a "good" value stored as an
extended attribute 'security.ima'.  The initial methods for validating
'security.ima' were hash and digital signature based.

Missing is the ability to specify the validation method required. This
patch set addresses this omission, by defining a new policy option
'appraise_type='.

As a result of this change, appraisal rules can now be written on a
per hook basis, resulting in different appraisal status results.  The
'ima_appraise_tcb' policy appraises all files owned by root.  A new
hook specific rule could specify that all kernel modules, for example,
require a digital signature.

This patchset defines the 'appraise_type' option and caches the
appraisal result on a per hook basis.

Changelog v2:
- Minor cleanup as described in patch descriptions

Mimi

Dmitry Kasatkin (1):
  ima: added policy support for 'security.ima' type

Mimi Zohar (3):
  ima: increase iint flag size
  ima: per hook cache integrity appraisal status
  ima: differentiate appraise status only for hook specific rules

 Documentation/ABI/testing/ima_policy  |  4 +-
 security/integrity/iint.c             | 10 ++++-
 security/integrity/ima/ima.h          | 13 +++++-
 security/integrity/ima/ima_appraise.c | 76 ++++++++++++++++++++++++++++++-----
 security/integrity/ima/ima_main.c     | 25 +++++++-----
 security/integrity/ima/ima_policy.c   | 43 +++++++++++++++++++-
 security/integrity/integrity.h        | 48 +++++++++++++++-------
 7 files changed, 181 insertions(+), 38 deletions(-)

-- 
1.8.1.rc3

