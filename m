Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3KYKXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:23:37 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:62706 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KYKXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:23:36 -0500
MIME-Version: 1.0
In-Reply-To: <20131125101147.GA2408@localhost>
References: <1385024065-29965-1-git-send-email-zhanghonghui@innofidei.com>
 <CACQ1gAiLesYEWmHkivAF=t8ekCFM=yDDyzkJTtduavNjp1g6wA@mail.gmail.com>
 <528EB1E3.7030101@innofidei.com> <20131122015237.GB3509@localhost>
 <528EBD0B.5010006@innofidei.com> <20131122114509.GB2414@localhost>
 <5292A7E7.5060003@innofidei.com> <20131125101147.GA2408@localhost>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 25 Nov 2013 11:23:14 +0100
Message-ID: <CACQ1gAi26WeiopptcZmBp6h0a5TacLo5mvVCOm6-H_1HtnwvXg@mail.gmail.com>
Subject: Re: [PATCH] Make the mtdblock read/write skip the bad nand sector
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Hans Zhang <zhanghonghui@innofidei.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        zhouguangming@innofidei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/25 Ezequiel Garcia <ezequiel.garcia@free-electrons.com>:
> On Mon, Nov 25, 2013 at 09:29:11AM +0800, Hans Zhang wrote:
>> On 2013/11/22 19:45, Ezequiel Garcia wrote:
>> >> Thanks for your reply.
>> >> This is for my embed system upgrade, I reserved one nand partition for filesystem
>> >> environment which will load to DDR while uboot booting.
>> >> This filesystem.uboot file should be able to read both by uboot and kernel, and
>> >> maybe written by uboot and kernel. There will be no filesystems upon the nand in
>> >> case the loader may not support some filesystem types while uboot booting.
>> >>
>> >> Seems that the trimmed environment of OS has get rid of the mtd-tools, So the dd
>> >> command was the most convenience tools to use by hand.
>> >>
>> > I still don't understand why are you using mtdblock. Why can't you write
>> > through the char device?
>>
>> Well, yes, write through the char device would be a solution.
>
> But, *why* are you writing through mtdblock instead?
>
>> I think that maybe it's an optional approach through mtdblock in case we do not have
>> the mtd-tools in our environments, we do provider a simpler way to write the NAND
>> through mtdblock.
>>
>
> Uh? simpler? Writing through mtdchat is as simple as it gets:
>
>   $ cat some_file.img > /dev/mtd0
>
> Sorry, but I'm still confused at what are you trying to accomplish.
I think that what Hans wants to do is:
 $ cat some_file.img > /dev/mtd0
And that doesn't fail on a bad block but jumps over it.
... Which is a bad idea.
But, likeyou, I didn't figured out why mtdblock instead of mtdchar.
