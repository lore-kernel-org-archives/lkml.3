Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab3LXChE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 21:37:04 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34666 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3LXCgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 21:36:48 -0500
Message-ID: <52B8F33C.3030808@gmail.com>
Date: Tue, 24 Dec 2013 10:36:44 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-metag@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggest] arch: metag: compiler: Are they compiler's issues?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helllo Maintainers:

When compile metag with allmodconfig, I met the 2 kinds of issues, I
guess they are compiler's issues, please help check, thanks.


Issue 1: compiler report the issue, but after check the related kernel
source code, I can not find any issues.

    CC [M]  drivers/isdn/hisax/s0box.o
  drivers/isdn/hisax/hscx_irq.c: In function 'hscx_fill_fifo':
  /upstream/linux-next/arch/metag/include/asm/io.h:62: error: 'asm' operand requires impossible reload
  make[3]: *** [drivers/isdn/hisax/s0box.o] Error 1
  make[2]: *** [drivers/isdn/hisax] Error 2
  make[1]: *** [drivers/isdn] Error 2
  make: *** [drivers] Error 2


Issue 2: they are about structure variables alignment, I guess, the
compiler can not notice about the "#pragma pack()" correctly.

    CC [M]  drivers/staging/lustre/lustre/lov/lov_pack.o
  drivers/staging/lustre/lustre/lov/lov_pack.c: In function 'lov_getstripe':
  drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: duplicate case value
  drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: previously used here
  make[5]: *** [drivers/staging/lustre/lustre/lov/lov_pack.o] Error 1
  make[4]: *** [drivers/staging/lustre/lustre/lov] Error 2
  make[3]: *** [drivers/staging/lustre/lustre] Error 2
  make[2]: *** [drivers/staging/lustre] Error 2
  make[1]: *** [drivers/staging] Error 2
  make: *** [drivers] Error 2

    MODPOST 2909 modules
  ERROR: "__compiletime_assert_426" [net/batman-adv/batman-adv.ko] undefined!
  ERROR: "__compiletime_assert_429" [net/batman-adv/batman-adv.ko] undefined!
  ERROR: "__compiletime_assert_425" [net/batman-adv/batman-adv.ko] undefined!
  ERROR: "__compiletime_assert_428" [net/batman-adv/batman-adv.ko] undefined!
  ERROR: "__compiletime_assert_427" [net/batman-adv/batman-adv.ko] undefined!
  ERROR: "__compiletime_assert_430" [net/batman-adv/batman-adv.ko] undefined!


Making cross-compiler:

  git clone git://github.com/img-meta/metag-buildroot.git metag-core-2013.11
  make meta2_defconfig.
  "cd metag-core-2013.11; cp -r output/host/usr/* /usr/"


Welcome any additional suggestions, discussions or completions.

Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
