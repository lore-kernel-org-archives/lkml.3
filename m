Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3AaUBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 15:01:18 -0500
Received: from mout.gmx.net ([212.227.15.18]:57652 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab3AaUBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 15:01:16 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/6DllvcdL6PoKc8bKrvrg6C7DaFWDBxVZuTBG0Ny
	pDwtap0pCqiOvZ
Date: Thu, 31 Jan 2013 21:01:10 +0100
From: Helge Deller <deller@gmx.de>
To: linux-parisc@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] parisc: unbreak automounter support on 64-bit kernel with
 32-bit userspace
Message-ID: <20130131200110.GA6032@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similiar to other 64 bit Linux targets autofs_wqt_t needs to be of type int
which has a size of 32 bits on 32- and 64-bit parisc kernels.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/include/uapi/linux/auto_fs.h b/include/uapi/linux/auto_fs.h
index 77cdba9..d551754 100644
--- a/include/uapi/linux/auto_fs.h
+++ b/include/uapi/linux/auto_fs.h
@@ -43,7 +43,7 @@
  */
 
 #if defined(__sparc__) || defined(__mips__) || defined(__x86_64__) \
- || defined(__powerpc__) || defined(__s390__)
+ || defined(__powerpc__) || defined(__s390__) || defined(__hppa__)
 typedef unsigned int autofs_wqt_t;
 #else
 typedef unsigned long autofs_wqt_t;
