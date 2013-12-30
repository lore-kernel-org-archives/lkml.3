Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab3L3Bc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 20:32:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49611 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab3L3Bcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 20:32:55 -0500
Message-ID: <52C0CD3F.7080808@zytor.com>
Date: Sun, 29 Dec 2013 17:32:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: KCONFIG_ALLCONFIG + allmodconfig = brokenness
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When KCONFIG_ALLCONFIG is used with "make allmodconfig", the result ends
up being largely the same as "make allyesconfig", because the resulting
kernel ends up with CONFIG_MODULES=n:

How to reproduce:

: tazenda 125 ; make O=../o.test allmodconfig
  GEN     /home/hpa/kernel/o.test/Makefile
scripts/kconfig/conf --allmodconfig Kconfig
#
# configuration written to .config
#
: tazenda 126 ; grep CONFIG_MODULES ../o.test/.config
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_MODULES=y
: tazenda 127 ; env KCONFIG_ALLCONFIG=/dev/null make O=../o.test
allmodconfig
  GEN     /home/hpa/kernel/o.test/Makefile
scripts/kconfig/conf --allmodconfig Kconfig
#
# configuration written to .config
#
: tazenda 128 ; grep CONFIG_MODULES ../o.test/.config
CONFIG_MODULES_USE_ELF_RELA=y
# CONFIG_MODULES is not set
