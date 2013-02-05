Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3BEPjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:39:54 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:50174 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3BEPju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:39:50 -0500
Date: Tue, 5 Feb 2013 23:39:44 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Jens Axboe" <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: For the condition "file->f_mode", when it failed, it should return EACCES rather than EBADF.
References: <2013020410070150879010@gmail.com>, 
	<20130205132117.GU15092@kernel.dk>
X-Priority: 3
X-GUID: A308D1DF-9DB7-4B97-9CAA-EE55E502D749
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[cn]
Mime-Version: 1.0
Message-ID: <201302052339385271010@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r15Fdt3k015449

>On Sun, Feb 03 2013, majianpeng wrote:
>> Hi all,
>> 	When I wanted to do discard operations,but i set the  openflag was O_RDONLY,it returned a EBADF rather than EACCES or EPERM.
>> I searched the code and found:
>> >case BLKDISCARD:
>> >case BLKSECDISCARD: {
>> >		uint64_t range[2];
>> 
>> >		if (!(mode & FMODE_WRITE))
>> >			return -EBADF;
>> Initial i thought there was error.But i searched all code of kernel and found some places like this.
>> 
>> The description of EBADF is "Bad file numbe". There are some places where returned EBADF like,
>> >if (!f.file)
>> >		return -EBADF;
>> 
>> So i think for checking file->f_mode when failed, it should return EACCESS.
>
>But that would break the ABI at this point. I agree with you, though,
>EBADF is not the right error for this case.
>
>-- 
>Jens Axboe
>
Sorry, can you explain in detail? Why can it break the ABI ?

Thanks!
Jianpeng Maÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
