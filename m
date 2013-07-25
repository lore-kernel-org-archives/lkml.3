Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3GYAs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:48:58 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51189 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3GYAsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:48:55 -0400
From: Roy Franz <roy.franz@linaro.org>
To: matt.fleming@intel.com, hpa@zytor.com
Cc: roy.franz@linaro.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] correct call to free_pages to specify memory size in pages, not bytes.
Date: Wed, 24 Jul 2013 17:48:43 -0700
Message-Id: <1374713324-23670-1-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found this bug while working on the EFI stub for ARM - free_pages
is being passed memory size in bytes instead of pages.  Since this is 
unrelated to ARM, I am submitting this separately from the patch set
that adds EFI stub support for ARM.  Those patches will depend on this
one, since the code in question is moved to a shared location and shared
by both x86 and ARM EFI stubs.

Roy Franz (1):
  correct call to free_pages to specify memory size in pages, not
    bytes.

 arch/x86/boot/compressed/eboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.10.4

