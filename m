Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaCIB0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 20:26:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:48824 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaCIB0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 20:26:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,616,1389772800"; 
   d="scan'208";a="488592775"
Date: Sun, 9 Mar 2014 09:26:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [m32r] ERROR: "memory_start" [fs/udf/udf.ko] undefined!
Message-ID: <20140309012628.GA9095@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hirokazu,

We noticed long standing build errors for m32104ut_defconfig and the
below bisected "first bad commit" actually fixed something to make the
kernel build go on to disclose these hidden errors.

first "bad" commit: fc31c7716355a226b8ed4e16f4581e5c8fa53570 kbuild: include limits.h in sumversion.c for PATH_MAX
date:   7 years ago
config: make ARCH=m32r m32104ut_defconfig

All error/warnings:

>> ERROR: "memory_start" [fs/udf/udf.ko] undefined!
>> ERROR: "memory_end" [fs/udf/udf.ko] undefined!
>> ERROR: "memory_end" [drivers/scsi/sg.ko] undefined!
>> ERROR: "memory_start" [drivers/scsi/sg.ko] undefined!
   ERROR: "memory_end" [drivers/media/video/c-qcam.ko] undefined!
   ERROR: "memory_start" [drivers/media/video/c-qcam.ko] undefined!
   ERROR: "memory_end" [drivers/media/video/bw-qcam.ko] undefined!
   ERROR: "memory_start" [drivers/media/video/bw-qcam.ko] undefined!
>> ERROR: "memory_end" [drivers/i2c/i2c-dev.ko] undefined!
>> ERROR: "memory_start" [drivers/i2c/i2c-dev.ko] undefined!
   ERROR: "ioport_map" [drivers/i2c/busses/i2c-elektor.ko] undefined!
   ERROR: "ioport_unmap" [drivers/i2c/busses/i2c-elektor.ko] undefined!
   ERROR: "iowrite8" [drivers/i2c/busses/i2c-elektor.ko] undefined!
   ERROR: "ioread8" [drivers/i2c/busses/i2c-elektor.ko] undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
