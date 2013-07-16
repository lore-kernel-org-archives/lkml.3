Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab3GPXfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:35:15 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:35700 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab3GPXfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:35:13 -0400
Date: Tue, 16 Jul 2013 18:35:07 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/7] Minor Alpha updates for 3.11
To: Richard Henderson <rth@twiddle.net>
Cc: linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
References: <1373994280-12047-1-git-send-email-rth@twiddle.net>
In-Reply-To: <1373994280-12047-1-git-send-email-rth@twiddle.net> (from
	rth@twiddle.net on Tue Jul 16 12:04:33 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1374017707.3719.11@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 12:04:33 PM, Richard Henderson wrote:
> Here's a set of minor updates for arch/alpha that should not
> be controversial.

I also note that I had to do this to get busybox to build against  
uClibc:

diff --git a/arch/alpha/include/uapi/asm/unistd.h  
b/arch/alpha/include/uapi/asm/unistd.h
index 801d28b..1146e78 100644
--- a/arch/alpha/include/uapi/asm/unistd.h
+++ b/arch/alpha/include/uapi/asm/unistd.h
@@ -23,7 +23,7 @@
  #define __NR_lseek		 19
  #define __NR_getxpid		 20
  #define __NR_osf_mount		 21
-#define __NR_umount		 22
+#define __NR_umount2		 22
  #define __NR_setuid		 23
  #define __NR_getxuid		 24
  #define __NR_exec_with_loader	 25	/* not implemented */
@@ -253,7 +253,6 @@
  #define __IGNORE_pause
  #define __IGNORE_time
  #define __IGNORE_utime
-#define __IGNORE_umount2

  /*
   * Linux-specific system calls begin at 300
@@ -279,7 +278,7 @@
  #define __NR_sysinfo		318
  #define __NR__sysctl		319
  /* 320 was sys_idle.  */
-#define __NR_oldumount		321
+#define __NR_umount		321
  #define __NR_swapon		322
  #define __NR_times		323
  #define __NR_personality	324

(Because busybox uses umount2() directly. There's a man page for it and  
everything.)

Rob