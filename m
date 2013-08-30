Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3H3JO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 05:14:58 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:49682 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab3H3JOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:14:55 -0400
Date: Fri, 30 Aug 2013 17:14:47 +0800
From: majianpeng <majianpeng@gmail.com>
To: viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [Question]: about the paramters of func generic_file_buffered_write.
X-Priority: 3
X-GUID: 98E6E0C5-5C46-4119-81BC-346F11BF7093
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201308301714452181275@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7U9F39k022640

Hi all,
	The definition of func generic_file_buffered_write is:
 		ssize_t generic_file_buffered_write(struct kiocb *, const struct iovec *,
                							unsigned long, loff_t, loff_t *, size_t, ssize_t);
The fourth and fifth paratmers indicate the current pos of file.
Every place which call this function, it set the fourth to iocb->ki_pos(maybe not but equal).
The fifth parameter is set &iocb->ki_pos.

I think we can remove two parameters. Those parameter can replace by the files of struct kiocb in the fun
of generic_file_buffered_write.

Or am i missing something?

Thansk!
Jianpeng Maÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
