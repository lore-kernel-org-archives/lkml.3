Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3BDCHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 21:07:13 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:61219 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab3BDCHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 21:07:11 -0500
Date: Mon, 4 Feb 2013 10:07:05 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Jens Axboe" <jaxboe@fusionio.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: For the condition "file->f_mode", when it failed, it should return EACCES rather than EBADF.
X-Priority: 3
X-GUID: A0D206B2-00E1-461B-A16E-B87C95368380
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <2013020410070150879010@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1427GbT005564

Hi all,
	When I wanted to do discard operations,but i set the  openflag was O_RDONLY,it returned a EBADF rather than EACCES or EPERM.
I searched the code and found:
>case BLKDISCARD:
>case BLKSECDISCARD: {
>		uint64_t range[2];

>		if (!(mode & FMODE_WRITE))
>			return -EBADF;
Initial i thought there was error.But i searched all code of kernel and found some places like this.

The description of EBADF is "Bad file numbe". There are some places where returned EBADF like,
>if (!f.file)
>		return -EBADF;

So i think for checking file->f_mode when failed, it should return EACCESS.


Jianpeng Ma
Thanks!


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
