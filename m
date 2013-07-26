Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3GZHIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:08:12 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35291 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3GZHII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:08:08 -0400
Date: Fri, 26 Jul 2013 15:08:00 +0800
From: majianpeng <majianpeng@gmail.com>
To: viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: question about splice
X-Priority: 3
X-GUID: 0D9A8E2F-D084-42A7-84C3-B46CF744C738
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307261507562231224@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6Q78KiT009437

Hi all,
	I used splice and found a prolem(at least i call).
The demo is:
A:splice(regularfileA--->pipe);
B:splice(pipe--->regularfileB)
Before do B, we modify the data of regA which now in pipe. The data to regularfileB willbe change.
If we used the buff
A:read(regA, buff);
B: write(buff, regB);
After A, the contend of regA can't effect the buff.
Review the code of splice,I know the pipe share the pagecache of regA.
Maybe this is not a problem or am i missing something?

Thanks!
Jianpeng Maÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
