Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3C0Loe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:44:34 -0400
Received: from intranet.asianux.com ([58.214.24.6]:24768 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3C0Lod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:44:33 -0400
X-Spam-Score: -100.8
Message-ID: <5152DB83.8080703@asianux.com>
Date: Wed, 27 Mar 2013 19:44:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: catalin.marinas@arm.com, Will Deacon <will.deacon@arm.com>,
        marc.zyngier@arm.com, anup.patel@linaro.org,
        Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] ARM64:kernel: compiling issue for early_console.
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

  it is a compiling issue for early_console.

  the make command:
    make V=1 EXTRA_CFLAGS=-W ARCH=arm64 allmodconfig
    make V=1 EXTRA_CFLAGS=-W ARCH=arm64 menuconfig
      set aarch64-linux-gnu- for tool chain prefix.
    make V=1 EXTRA_CFLAGS=-W ARCH=arm64

  the error message:
    arch/arm64/kernel/early_printk.c: At top level:
    arch/arm64/kernel/early_printk.c:98:23: error: conflicting types for ‘early_console’
    In file included from arch/arm64/kernel/early_printk.c:20:0:
    include/linux/console.h:145:24: note: previous declaration of ‘early_console’ was here
    make[1]: *** [arch/arm64/kernel/early_printk.o] Error 1
    make: *** [arch/arm64/kernel] Error 2


  I guess, we can just reference the 32-bit arm implementation is ok.
    (it is in arch/arm/kernel/early_printk.c line 32..44)

  if really just like what I guess, may I send related patch for it ?

  :-)


gchen.
