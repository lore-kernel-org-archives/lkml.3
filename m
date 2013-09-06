Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab3IFVr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:47:56 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54173 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3IFVrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:47:55 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: behanw@converseincode.com, Russell King <rmk+kernel@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Will Drewry <wad@chromium.org>
Subject: [PATCH] arm: LLVMLinux: Use __builtin_frame_address to get thread info
Date: Fri,  6 Sep 2013 17:47:39 -0400
Message-Id: <1378504062-9117-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

The LLVMLinux Project is working to be able to build the Linux kernel with
clang/LLVM. With the release of LLVM 3.3 clang is now able to compile the Linux
kernel with a number of small patches (available from the LLVMLinux git repo).

Use the frame pointer to calculate the start of the stack for current_thread_info()
The existing code uses the stack pointer to do this calculation.
Using the frame pointer yeilds the same value in a portable way.
This change supports being able to compile the kernel with gcc and Clang.

Behan Webster (1):
  arm: LLVMLinux: Calculate current_thread_info from fp

 arch/arm/include/asm/thread_info.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
1.8.1.2

