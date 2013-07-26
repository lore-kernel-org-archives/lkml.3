Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3GZHyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:54:09 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65200 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab3GZHyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:54:06 -0400
Date: Fri, 26 Jul 2013 15:53:54 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Gu Zheng" <guz.fnst@cn.fujitsu.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: question about splice
References: <201307261507562231224@gmail.com>, 
	<51F22287.8050204@cn.fujitsu.com>
X-Priority: 3
X-GUID: 8F4FA787-7194-414C-A5A1-964377F14384
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307261553424020855@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6Q7sDRC009641

>Hi Jianpeng,
>
>On 07/26/2013 03:08 PM, majianpeng wrote:
>
>> Hi all,
>> 	I used splice and found a prolem(at least i call).
>> The demo is:
>> A:splice(regularfileA--->pipe);
>> B:splice(pipe--->regularfileB)
>> Before do B, we modify the data of regA which now in pipe. The data to regularfileB willbe change.
>> If we used the buff
>> A:read(regA, buff);
>> B: write(buff, regB);
>> After A, the contend of regA can't effect the buff.
>> Review the code of splice,I know the pipe share the pagecache of regA.
>
>Right. And also this is the splice's original design intention, using share mmap rather
>than copy_to_user/copy_from_user in order to achieve zero-copy.
>
If it use some method like COW, i think it can avoid this problem.
>Thanks,
>Gu
>
>> Maybe this is not a problem or am i missing something?
>
>> 
>> Thanks!
>> Jianpeng MaN‹§²æìr¸›yúèšØb²X¬¶Ç§vØ^?)Şº{.n?+‰·¥Š{±‘êçzX§¶›¡Ü¨}©²Æ z?&j:+v‰¨?«‘êçzZ+€?+zf£¢·hšˆ§~†­†Ûi?ûàz?®w¥¢??™¨è­?&?)ß¢f”ù^jÇ«y§m…á@A«a¶Ú?
>0¶ìh?å’i
>
>
Thanks!
Jianpeng Ma
>Hi Jianpeng,
>
>On 07/26/2013 03:08 PM, majianpeng wrote:
>
>> Hi all,
>> 	I used splice and found a prolem(at least i call).
>> The demo is:
>> A:splice(regularfileA--->pipe);
>> B:splice(pipe--->regularfileB)
>> Before do B, we modify the data of regA which now in pipe. The data to regularfileB willbe change.
>> If we used the buff
>> A:read(regA, buff);
>> B: write(buff, regB);
>> After A, the contend of regA can't effect the buff.
>> Review the code of splice,I know the pipe share the pagecache of regA.
>
>Right. And also this is the splice's original design intention, using share mmap rather
>than copy_to_user/copy_from_user in order to achieve zero-copy.
>
>Thanks,
>Gu
>
>> Maybe this is not a problem or am i missing something?
>
>> 
>> Thanks!
>> Jianpeng MaN‹§²æìr¸›yúèšØb²X¬¶Ç§vØ^?)Şº{.n?+‰·¥Š{±‘êçzX§¶›¡Ü¨}©²Æ z?&j:+v‰¨?«‘êçzZ+€?+zf£¢·hšˆ§~†­†Ûi?ûàz?®w¥¢??™¨è­?&?)ß¢f”ù^jÇ«y§m…á@A«a¶Ú?
>0¶ìh?å’i
>
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
