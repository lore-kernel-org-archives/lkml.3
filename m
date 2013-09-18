Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3IRN1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:27:51 -0400
Received: from nm49-vm4.bullet.mail.gq1.yahoo.com ([67.195.87.234]:38954 "EHLO
	nm49-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab3IRN01 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:26:27 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2013 09:26:27 EDT
X-Yahoo-Newman-Id: 698532.66900.bm@smtp237.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zEkeVs8VM1m1NaEUqSirbKR2WGKMyeHjghxavjYH3.05MM9
 z67OVCoKI8OSC2HH3rzY6.v7sAOHxFqUEfg1QmFcnG5J6iPTTR.pqhgATJkW
 11wTXz1_fZBXDXsnNiU_XHZ_qFoVAMR6L.CWpw8F9igO5O_3X.DdwM2kAcef
 Ythtqb1YiXIYim_C0dsRt3sF.yNha5BZrjf_0CDtnyC4qD0izipa2FOGUY._
 qx9C.zWJjusYWx33zDYBxBsqIaVV9K_TCvT7JrqBBBfpOSQQWPjV9nlbR8hy
 PmSi90.Jn_hA.E8QJNn_G58yAPyo9PVRnBGUfKkOr5J9ouBePw3Z._hDXd6s
 mPwbOEswXr.nFmyc8Rnatsji23WnY1wbkEDTGAAepzQ2585sA2Ptlbgml3JH
 0.7aqiK79Cuae5Fuct3zulMDWfeIiY1io76nu0YxY1YTJ.YkkBlkwJhCNAiQ
 jxdBGM5_mfbQz_DiFUGi14_dddIxULMj5uwOFTwlsRiK9t6IH0YOYj2sPhiL
 bLRAyneLUWFR8leNgJVtdcHhopuZhiLD2WtxSlg0sGYXQfvHnpL9oowETB9t
 qn6fLoY.5hXgXllXdKSLg9RJuPsp5L1XwQ88oRFdlzMnD39BhgI_4l8vCB70
 Ct6RCN5YYApdVc_ZtHtIQiZH9e6i4f3nYf0CxYoBFEa.1rXlZMjjjwg--
X-Yahoo-SMTP: htk5gkqswBA5b6DEGtLWdV5cbbEO
X-Rocket-Received: from localhost.localnet (ad_sicks@107.196.206.9 with )
        by smtp237.mail.gq1.yahoo.com with SMTP; 18 Sep 2013 13:20:18 +0000 UTC
From: "Jeff P. Zacher" <ad_sicks@yahoo.com>
To: linux-kernel@vger.kernel.org
Subject: Dependency bug in the uvcvideo Kconfig
Date: Wed, 18 Sep 2013 08:18:40 -0500
Message-ID: <1828294.VXnhqsmrEo@localhost>
Organization: Zacher Network Solutions
User-Agent: KMail/4.10.5 (Linux/3.10.7-gentoo; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not subscribed, please CC'me in replies:

There seems to be a dependency bug in the Kconfig for the uvcvideo kernel 
module.  If uvcvideo is built in and usb support is built as a module, the 
kernel build will fail with the obviously missing dependanies.


Error logs:

* ERROR: Failed to compile the "bzImage" target...
* 
* -- Grepping log... --
* 
*  SHIPPED scripts/genksyms/keywords.hash.c
*  SHIPPED scripts/genksyms/parse.tab.h
*  SHIPPED scripts/genksyms/parse.tab.c
*  HOSTCC  scripts/genksyms/lex.lex.o
*scripts/genksyms/lex.lex.c_shipped: In function ‘yylex1’:
*scripts/genksyms/lex.lex.c_shipped:904:1: warning: ignoring return value of 
‘fwrite’, declared with attribute warn_unused_result [-Wunused-result]
*--
*  CC      drivers/video/console/font_8x16.o
*  CC      drivers/video/console/softcursor.o
*  CC      sound/core/seq/seq_memory.o
*  CC      drivers/video/console/fbcondecor.o
*  CC      sound/core/seq/seq_queue.o
*drivers/video/console/fbcondecor.c:511:6: warning: function declaration isn’t 
a prototype [-Wstrict-prototypes]
*--
*(.text+0xf8fb1): undefined reference to `usb_submit_urb'
*drivers/built-in.o: In function `uvc_init':
*uvc_driver.c:(.init.text+0x908a): undefined reference to 
`usb_register_driver'
*drivers/built-in.o: In function `uvc_cleanup':
*uvc_driver.c:(.exit.text+0x67e): undefined reference to `usb_deregister'
*make: *** [vmlinux] Error 1
*--
* Running with options: --lvm --menuconfig all
* Using genkernel.conf from /etc/genkernel.conf
* Sourcing arch-specific config.sh from 
/usr/share/genkernel/arch/x86_64/config.sh ..
* Sourcing arch-specific modules_load from 
/usr/share/genkernel/arch/x86_64/modules_load ..
*
* ERROR: Failed to compile the "bzImage" target...
* 
* -- End log... --

Compiling uvc as a module allows the compilation to complete.

Platform x86_64

Ref: http://forums.gentoo.org/viewtopic-p-7398782.html#7398782


-- Jeff P. Zacher
ad_sicks@yahoo.com

