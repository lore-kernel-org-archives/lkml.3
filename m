Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3KOFvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:51:41 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:50201 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3KOFvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:51:33 -0500
Message-ID: <5285B64E.7030507@synopsys.com>
Date: Fri, 15 Nov 2013 11:21:10 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tony Breeds <tony@bakeyournoodle.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>
Subject: ARC cross compiler hosting on kernel.org
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Can you please host a ARC cross compiler on
https://www.kernel.org/pub/tools/crosstool

Mainline buildroot supports ARC (alas that build system doesn't generate a
relocatable toolchain).

Or you can simply use our homegrown build-system to checkout and build tools
(which can even do a relocatable toolchain provided you have patchelf installed)

git clone git@github.com:foss-for-synopsys-dwc-arc-processors/toolchain.git
cd toolchain
./build-all.sh --auto-checkout --auto-pull --rel-rpaths --no-elf32 \
--target-cflags "-gdwarf-2"

ARC defconfig requires an INITRAMFS at a relative path. You can either disable it
(I have a patch queued up for a !RAMFS defconfig too).

Let me know if you run into any issues.

Thx,
-Vineet
