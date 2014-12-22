Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbaLVPVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:21:01 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64296 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaLVPU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:20:59 -0500
From: mathieu.poirier@linaro.org
To: jason@lakedaemon.net, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH v2 0/2] staging: skein: Fixing various coding style problems
Date: Mon, 22 Dec 2014 08:20:37 -0700
Message-Id: <1419261639-17157-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

This patchset is fixing miscellaneous coding style problems as reported
by checkpatch.  More interesting is the removal of 'do {} while (0) loop'
statements for single line macros.  The following provides a guarantee the
semantic of the object code hasn't been altered by the rectification:

mpoirier@t430:~/work/kernel1$
146320048532 staging: skein: Fixing single statement macro checkpatch warning
ef68ffa9fd3e staging: skein: Fixing trailing whitespace error
97bf6af1f928 Linux 3.19-rc1
mpoirier@t430:~/work/kernel1$ git reset --hard 97bf6af1f928
HEAD is now at 97bf6af1f928 Linux 3.19-rc1
mpoirier@t430:~/work/kernel1$ make drivers/staging/skein/skein_block.o
  CHK     include/config/kernel.release
  UPD     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/staging/skein/skein_block.o
mpoirier@t430:~/work/kernel1$ ./scripts/objdiff record drivers/staging/skein/skein_block.o
mpoirier@t430:~/work/kernel1$ git reset --hard 146320048532
HEAD is now at 146320048532 staging: skein: Fixing single statement macro checkpatch warning
mpoirier@t430:~/work/kernel1$ make drivers/staging/skein/skein_block.o
  CHK     include/config/kernel.release
  UPD     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/staging/skein/skein_block.o
mpoirier@t430:~/work/kernel1$ ./scripts/objdiff record drivers/staging/skein/skein_block.o
mpoirier@t430:~/work/kernel1$ ./scripts/objdiff diff 97bf6af1f928 146320048532
mpoirier@t430:~/work/kernel1$

New to this patchset:
. Introduction of a cover letter that includes a scripts/objdiff snapshot
. Splitting of the change set by semantic

Mathieu Poirier (2):
  staging: skein: Fixing trailing whitespace error
  staging: skein: Fixing single statement macro checkpatch warning

 drivers/staging/skein/skein_block.c   | 17 ++++-------------
 drivers/staging/skein/skein_generic.c |  1 -
 2 files changed, 4 insertions(+), 14 deletions(-)

-- 
1.9.1

