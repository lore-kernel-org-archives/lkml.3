Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbaLJTuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:50:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:29858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884AbaLJTuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:50:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770837"
Message-ID: <5488A3C0.1080403@linux.intel.com>
Date: Wed, 10 Dec 2014 11:49:20 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT pull] x86 mpx support for 3.19
References: <alpine.DEB.2.11.1412091504490.16275@nanos> <CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>
In-Reply-To: <CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030205010005070104060003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030205010005070104060003
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 12/10/2014 11:05 AM, Linus Torvalds wrote:
> On Tue, Dec 9, 2014 at 6:08 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Why would I want to enable this in my kernel when there are no actual
> CPU's out yet that support it? And even when there are, why would I do
> it if the CPU I have doesn't support it?

There's no good reason to enable it except for testing (compile, or
making sure we didn't screw up the #BR code for CPUs without MPX).

Patch is attached to add the following:

> config X86_INTEL_MPX
>         prompt "Intel MPX (Memory Protection Extensions)" if EXPERT
>         def_bool y
>         depends on CPU_SUP_INTEL
>         ---help---
>           MPX provides hardware features that can be used in
>           conjunction with compiler-instrumented code to check
>           memory references.  It is designed to detect buffer
>           overflow or underflow bugs.
> 
>           Enabling this option will make the kernel larger and
>           slightly increase the size of some data structures.
> 
>           If unsure, say Y.



--------------030205010005070104060003
Content-Type: text/x-patch;
 name="x86-mpx-real-config-option.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x86-mpx-real-config-option.patch"


From: Dave Hansen <dave.hansen@linux.intel.com>

Give MPX a real config option.  The CPUs that support it
(referenced here):

	https://software.intel.com/en-us/forums/topic/402393

are not available publicly, so we need to make it somewhat
easy to disable.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/Kconfig |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN arch/x86/Kconfig~x86-mpx-real-config-option arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-mpx-real-config-option	2014-12-10 11:19:13.638835732 -0800
+++ b/arch/x86/Kconfig	2014-12-10 11:30:27.080209235 -0800
@@ -248,10 +248,6 @@ config HAVE_INTEL_TXT
 	def_bool y
 	depends on INTEL_IOMMU && ACPI
 
-config X86_INTEL_MPX
-	def_bool y
-	depends on CPU_SUP_INTEL
-
 config X86_32_SMP
 	def_bool y
 	depends on X86_32 && SMP
@@ -1575,6 +1571,21 @@ config X86_SMAP
 
 	  If unsure, say Y.
 
+config X86_INTEL_MPX
+	prompt "Intel MPX (Memory Protection Extensions)" if EXPERT
+	def_bool y
+	depends on CPU_SUP_INTEL
+	---help---
+	  MPX provides hardware features that can be used in
+	  conjunction with compiler-instrumented code to check
+	  memory references.  It is designed to detect buffer
+	  overflow or underflow bugs.
+
+	  Enabling this option will make the kernel larger and
+	  slightly increase the size of some data structures.
+
+	  If unsure, say Y.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
_

--------------030205010005070104060003--
