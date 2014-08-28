Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaH1VLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 17:11:46 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:52240 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaH1VLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 17:11:44 -0400
MIME-Version: 1.0
In-Reply-To: <53FF9425.6010302@infradead.org>
References: <1409258060-21897-1-git-send-email-avagin@openvz.org>
	<53FF9425.6010302@infradead.org>
Date: Fri, 29 Aug 2014 01:11:42 +0400
Message-ID: <CANaxB-yWkHwTdbEKLBMbYdXOEp7rQPgr-oZ6c9CU4t_x--2jmA@mail.gmail.com>
Subject: Re: [PATCH] Documentation/video4linux: don't build without CONFIG_VIDEO_V4L2
From: Andrey Wagin <avagin@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Peter Foley <pefoley2@pefoley.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-29 0:42 GMT+04:00 Randy Dunlap <rdunlap@infradead.org>:
> On 08/28/14 13:34, Andrey Vagin wrote:
>> Otherwise we get warnings:
>> WARNING: "vb2_ops_wait_finish" [Documentation//video4linux/v4l2-pci-skeleton.ko] undefined!
>> WARNING: "vb2_ops_wait_prepare" [Documentation//video4linux/v4l2-pci-skeleton.ko] undefined!
>> ...
>> WARNING: "video_unregister_device" [Documentation//video4linux/v4l2-pci-skeleton.ko] undefined!
>>
>> Fixes: 8db5ab4b50fb ("Documentation: add makefiles for more targets")
>>
>> Cc: Peter Foley <pefoley2@pefoley.com>
>> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Signed-off-by: Andrey Vagin <avagin@openvz.org>
>> ---
>>  Documentation/video4linux/Makefile | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/video4linux/Makefile b/Documentation/video4linux/Makefile
>> index d58101e..f19f38e 100644
>> --- a/Documentation/video4linux/Makefile
>> +++ b/Documentation/video4linux/Makefile
>> @@ -1 +1,3 @@
>> +ifneq ($(CONFIG_VIDEO_V4L2),)
>>  obj-m := v4l2-pci-skeleton.o
>> +endif
>>
>
> The Kconfig file for this module says:
>
> config VIDEO_PCI_SKELETON
>         tristate "Skeleton PCI V4L2 driver"
>         depends on PCI && BUILD_DOCSRC
>         depends on VIDEO_V4L2 && VIDEOBUF2_CORE && VIDEOBUF2_MEMOPS
>
> so it should already be limited to VIDEO_V4L2 being enabled.
>
> What kernel or linux-next version did you see a problem with?

Eh, I'm late. It was fixed already

commit 81820f32ffaf393d9379c326d670257c63306a26
Author: Mark Brown <broonie@kernel.org>
Date:   Wed Aug 27 10:18:51 2014 +1000

    v4l2-pci-skeleton: Only build if PCI is available

Sorry for the noise.

>
> Please send the failing .config file so that I can check it.
>
> Thanks.
>
> --
> ~Randy
