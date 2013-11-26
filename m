Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab3KZX1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:27:08 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:51195 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3KZX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:27:03 -0500
X-Auth-Info: qxyaEiakoj8sWUR/aNgmysEObGyaGKyjUsA1YgDMCUM=
From: Marek Vasut <marex@denx.de>
To: linux-kernel@vger.kernel.org
Subject: Possible bug in firmware/Makefile
Date: Wed, 27 Nov 2013 00:26:58 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: ming.lei@canonical.com, mike.marciniszyn@intel.com, roland@purestorage.com,
        dean.luick@intel.com, vinit.abhay.agnihotri@intel.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201311270026.58626.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am observing a possible bug when trying to build external firmware file into 
the kernel. Here are the steps to reproduce the problem I observe.

1) Retrieve Linux 3.13-rc1 (I can confirm this in 3.10.18 stable as well)
2) Clean up the source tree
$ git clean -fdx
3) Configure the kernel (minimal configuration is sufficient)
$ make allnoconfig
4) Produce a dummy firmware file to be built into the kernel
$ echo "hello" > /tmp/firmware.fw
5) Build the kernel (note: I tested this bug on ARCH=arm and ARCH=x86_64)
$ make CONFIG_EXTRA_FIRMWARE="firmware.fw" CONFIG_EXTRA_FIRMWARE_DIR="/tmp/"

What I observe is this output:

  LD      sound/built-in.o
make[1]: *** No rule to make target `include/config/extra/firmware/dir.h', 
needed by `firmware//tmp/firmware.fw.gen.S'.  Stop.
make: *** [firmware] Error 2

Interestingly enough, if I place these same options into the kernel .config, 
using the commands like these below for example, the kernel builds correctly.

echo -e \ 
  'CONFIG_EXTRA_FIRMWARE_DIR="/tmp/"\nCONFIG_EXTRA_FIRMWARE="firmware.fw"' \
  >> .config
make oldconfig
make

Is this a known issue please? Is there a way to specify the extra firmware file 
to be built into the kernel on the kernel build command line please?

Thank you very much!

Best regards,
Marek Vasut
