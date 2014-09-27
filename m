Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaI0BLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 21:11:12 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37776 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaI0BLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 21:11:10 -0400
From: Behan Webster <behanw@converseincode.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: behanw@converseincode.com, archit@ti.com, daniel.vetter@ffwll.ch,
        geert@linux-m68k.org, laurent.pinchart@ideasonboard.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, robdclark@gmail.com
Subject: [PATCH 0/2] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Fri, 26 Sep 2014 18:10:51 -0700
Message-Id: <1411780253-4492-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the use of nested functions where a normal function will suffice.

Nested functions are not liked by upstream kernel developers in general. Their
use breaks the use of clang as a compiler, and doesn't make the code any
better.

This code now works for both gcc and clang.

The LLVMLinux project aims to fully build the Linux kernel using both gcc and
clang (the C front end for the LLVM compiler infrastructure project). 

Behan Webster (2):
  arm, fbdev, omap2, LLVMLinux: Remove nested function from omap2 dss
  arm, fbdev, omap2, LLVMLinux: Remove nested function from omapfb

 drivers/video/fbdev/omap2/dss/dispc-compat.c   |  9 +++++----
 drivers/video/fbdev/omap2/dss/manager-sysfs.c  | 16 +++++++++-------
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c | 14 +++++++-------
 3 files changed, 21 insertions(+), 18 deletions(-)

-- 
1.9.1

