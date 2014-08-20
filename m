Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaHTGMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:12:03 -0400
Received: from infra.glanzmann.de ([88.198.249.254]:44451 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaHTGMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:12:02 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Aug 2014 02:12:01 EDT
Date: Wed, 20 Aug 2014 08:04:24 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Regression: Can't compile x86_64 with 32 Bit userland:
 arch/x86/purgatory/purgatory.c:1:0: error: code model 'large' not supported
 in the 32 bit mode
Message-ID: <20140820060423.GA14660@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I used to compile 64 Bit Kernel on 32 Bit Userland and until v3.16 it
worked. But with todays git head from Linus it does not:

(mini) [~/work/linux-2.6] make                                                                                                                                                                         scripts/kconfig/conf --silentoldconfig Kconfig
  CHK     include/config/kernel.release
  UPD     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      arch/x86/purgatory/purgatory.o
arch/x86/purgatory/purgatory.c:1:0: error: code model 'large' not supported in the 32 bit mode
make[1]: *** [arch/x86/purgatory/purgatory.o] Error 1
make: *** [archprepare] Error 2

I'll do git bisect to identify the offending commit.

I'm using Debian Wheezy 7 32 Bit on x86 with gcc version 4.7.2 (Debian
4.7.2-5).

Cheers,
        Thomas
