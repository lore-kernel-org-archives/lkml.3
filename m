Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbaCRT0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:26:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845AbaCRT0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 0/5] x86/boot: Some string function cleanup and consolidation
Date: Tue, 18 Mar 2014 15:26:35 -0400
Message-Id: <1395170800-11059-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I have tried cleaning up a bit the usage of string functions in arch/x86/boot/.

I have created x86/boot/string.h which all the callers can include and by
default they get the built in definition of memcpy, memset and memcmp. Those
who want to use optimized version of these functions, need to #undef respective
macro and link again the approprate string.c file which provides the function
definition.

After this change I am planning to include x86/boot/string.h in purgatory
code and get built-in definitions of memcpy, memset and memcmp.

There seem to be lot of magic going on in arch/x86/boot/. I do not claim
to understand it all. Hopefully above changes do not break anything.

Please have a look.

Thanks
Vivek


Vivek Goyal (5):
  x86/boot: undef memcmp before providing a new definition
  x86/boot: Create a separate string.h file to provide standard string
    functions
  x86/boot: Move optmized memcpy() 32/64 bit versions to
    compressed/string.c
  x86/boot: Move memcmp() into string.h and string.c
  x86/boot: Move memset() definition in compressed/string.c

 arch/x86/boot/boot.h              | 13 ----------
 arch/x86/boot/compressed/misc.c   | 51 ++++++---------------------------------
 arch/x86/boot/compressed/string.c | 46 ++++++++++++++++++++++++++++++-----
 arch/x86/boot/cpucheck.c          |  1 +
 arch/x86/boot/edd.c               |  1 +
 arch/x86/boot/main.c              |  1 +
 arch/x86/boot/regs.c              |  1 +
 arch/x86/boot/string.c            | 14 +++++++++++
 arch/x86/boot/string.h            | 21 ++++++++++++++++
 arch/x86/boot/video-vesa.c        |  1 +
 10 files changed, 88 insertions(+), 62 deletions(-)
 create mode 100644 arch/x86/boot/string.h

-- 
1.8.5.3

