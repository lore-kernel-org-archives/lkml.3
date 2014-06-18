Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141AbaFRIqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:46:39 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:47616 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039AbaFRIqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:46:36 -0400
MIME-Version: 1.0
Date: Wed, 18 Jun 2014 10:46:35 +0200
Message-ID: <CAF1_xX2oeG0YCLaLZR9ZUY2qiD0-sVB6L10dZppnae7iZV_U3g@mail.gmail.com>
Subject: Regression: firmware: Simplify directory creation + b43 = fails to build
From: Ronald <ronald645@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, mmarek@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel developers,

Latest git HEAD (from Torvalds):

  CC      drivers/base/firmware_class.o
  LD      drivers/base/built-in.o
  MK_FW   firmware/b43/ucode5.fw.gen.S
/bin/sh: firmware/b43/ucode5.fw.gen.S: Bestand of map bestaat niet
(file or directory does not exist, it should not have the .gen.S
suffix)
/bin/sh: firmware/b43/ucode5.fw.gen.S: Bestand of map bestaat niet
... snip ...
/bin/sh: firmware/b43/ucode5.fw.gen.S: Bestand of map bestaat niet
firmware/Makefile:185: recept voor doel 'firmware/b43/ucode5.fw.gen.S'
is mislukt
make[1]: *** [firmware/b43/ucode5.fw.gen.S] Fout 1
Makefile:893: recept voor doel 'firmware' is mislukt
make: *** [firmware] Fout 2
make: *** Wachten op onvoltooide taken...

 ==> git revert 5180d5f
[bleed 55a169f] Revert "firmware: Simplify directory creation"
 2 files changed, 38 insertions(+), 16 deletions(-)
09:57 ronald@Charlie /usr/src/linux :)
 ==> time make -j2
... snip ...
  LD      drivers/base/built-in.o
  MKDIR   firmware/b43/
  MK_FW   firmware/b43/ucode5.fw.gen.S
  MK_FW   firmware/b43/b0g0initvals5.fw.gen.S
  MK_FW   firmware/b43/b0g0bsinitvals5.fw.gen.S
  MK_FW   firmware/b43/pcm5.fw.gen.S
  AS      firmware/b43/ucode5.fw.gen.o
  AS      firmware/b43/b0g0initvals5.fw.gen.o
  AS      firmware/b43/b0g0bsinitvals5.fw.gen.o
  AS      firmware/b43/pcm5.fw.gen.o
  LD      firmware/built-in.o

If you require more info, please let me know.
