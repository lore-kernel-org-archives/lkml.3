Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab3AOW2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:28:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:41447 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651Ab3AOW2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 053/221] mfd: Remove Unicode Byte Order Marks from da9055
Date: Tue, 15 Jan 2013 10:49:40 -0800
Message-Id: <20130115185001.850895849@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 90a38d999739f35f4fc925c875e6ee518546b66c upstream.

Older gcc (< 4.4) doesn't like files starting with Unicode BOMs:

include/linux/mfd/da9055/core.h:1: error: stray ‘\357’ in program
include/linux/mfd/da9055/core.h:1: error: stray ‘\273’ in program
include/linux/mfd/da9055/core.h:1: error: stray ‘\277’ in program
include/linux/mfd/da9055/pdata.h:1: error: stray ‘\357’ in program
include/linux/mfd/da9055/pdata.h:1: error: stray ‘\273’ in program
include/linux/mfd/da9055/pdata.h:1: error: stray ‘\277’ in program
include/linux/mfd/da9055/reg.h:1: error: stray ‘\357’ in program
include/linux/mfd/da9055/reg.h:1: error: stray ‘\273’ in program
include/linux/mfd/da9055/reg.h:1: error: stray ‘\277’ in program

Remove the BOMs, the rest of the files is plain ASCII anyway.

Output of "file" before:

include/linux/mfd/da9055/core.h:  UTF-8 Unicode (with BOM) C program text
include/linux/mfd/da9055/pdata.h: UTF-8 Unicode (with BOM) C program text
include/linux/mfd/da9055/reg.h:   UTF-8 Unicode (with BOM) C program text

Output of "file" after:

include/linux/mfd/da9055/core.h:  ASCII C program text
include/linux/mfd/da9055/pdata.h: ASCII C program text
include/linux/mfd/da9055/reg.h:   ASCII C program text

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mfd/da9055/core.h  |    2 +-
 include/linux/mfd/da9055/pdata.h |    2 +-
 include/linux/mfd/da9055/reg.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mfd/da9055/core.h
+++ b/include/linux/mfd/da9055/core.h
@@ -1,4 +1,4 @@
-﻿/*
+/*
  * da9055 declarations for DA9055 PMICs.
  *
  * Copyright(c) 2012 Dialog Semiconductor Ltd.
--- a/include/linux/mfd/da9055/pdata.h
+++ b/include/linux/mfd/da9055/pdata.h
@@ -1,4 +1,4 @@
-﻿/* Copyright (C) 2012 Dialog Semiconductor Ltd.
+/* Copyright (C) 2012 Dialog Semiconductor Ltd.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
--- a/include/linux/mfd/da9055/reg.h
+++ b/include/linux/mfd/da9055/reg.h
@@ -1,4 +1,4 @@
-﻿/*
+/*
  * DA9055 declarations for DA9055 PMICs.
  *
  * Copyright(c) 2012 Dialog Semiconductor Ltd.


