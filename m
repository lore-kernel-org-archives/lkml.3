Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaCaRYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:24:47 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:37803 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaCaRYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:24:45 -0400
MIME-Version: 1.0
In-Reply-To: <5339840D.9000702@xs4all.nl>
References: <1396277573-9513-1-git-send-email-prabhakar.csengg@gmail.com>
 <1396277573-9513-2-git-send-email-prabhakar.csengg@gmail.com> <5339840D.9000702@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 31 Mar 2014 22:54:14 +0530
Message-ID: <CA+V-a8s_mZNEuN0JHH_rpJU=zab57Q_LfLT_onwj0=ykgoUm0g@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: davinci: vpif capture: upgrade the driver with
 v4l offerings
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Mon, Mar 31, 2014 at 8:34 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> This looks really nice!
>
Writing a video driver has become really easy with almost 90% of work
done by v4l core itself :)

> I'll do a full review on Friday, but in the meantime can you post the output
OK.

> of 'v4l2-compliance -s' using the latest v4l2-compliance version? I've made
> some commits today, so you need to do a git pull of v4l-utils.git.
>
I had compilation failures for v4l2-compliance following is the patch
fixing that, (I am
facing some issues in cross compilation once done I'll post the o/p of it)

--------------X------------X-------------------

>From 14029f4ca57be5f2b0ec053d375655ca5a60f698 Mon Sep 17 00:00:00 2001
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 31 Mar 2014 22:24:33 +0530
Subject: [PATCH] v4l-utils: v4l-compliance: fix compilation

this patch fixes following build error,

In file included from v4l2-compliance.h:31,
                 from v4l2-compliance.cpp:37:
./cv4l-helpers.h:9: error: a class-key must be used when declaring a friend
./cv4l-helpers.h:9: error: friend declaration does not name a class or function
./cv4l-helpers.h: In member function 'int cv4l_buffer::querybuf(const
cv4l_queue&, unsigned int)':
./cv4l-helpers.h:103: error: 'v4l_fd* cv4l_queue::fd' is protected
./cv4l-helpers.h:213: error: within this context
./cv4l-helpers.h: In member function 'int cv4l_buffer::dqbuf(const
cv4l_queue&)':
./cv4l-helpers.h:103: error: 'v4l_fd* cv4l_queue::fd' is protected
./cv4l-helpers.h:221: error: within this context
./cv4l-helpers.h: In member function 'int cv4l_buffer::qbuf(const cv4l_queue&)':
./cv4l-helpers.h:103: error: 'v4l_fd* cv4l_queue::fd' is protected
./cv4l-helpers.h:229: error: within this context
./cv4l-helpers.h: In member function 'int
cv4l_buffer::prepare_buf(const cv4l_queue&)':
./cv4l-helpers.h:103: error: 'v4l_fd* cv4l_queue::fd' is protected
./cv4l-helpers.h:237: error: within this context
v4l2-compliance.cpp: In function 'void v4l_fd_test_init(v4l_fd*, int)':
v4l2-compliance.cpp:132: error: invalid conversion from 'void*
(*)(void*, size_t, int, int, int, int64_t)' to 'void* (*)(void*,
size_t, int, int, int, off_t)'

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 utils/v4l2-compliance/cv4l-helpers.h    |    2 +-
 utils/v4l2-compliance/v4l2-compliance.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/v4l2-compliance/cv4l-helpers.h
b/utils/v4l2-compliance/cv4l-helpers.h
index 2423ef9..e2729a6 100644
--- a/utils/v4l2-compliance/cv4l-helpers.h
+++ b/utils/v4l2-compliance/cv4l-helpers.h
@@ -6,7 +6,7 @@
 class cv4l_buffer;

 class cv4l_queue : v4l_queue {
-    friend cv4l_buffer;
+    friend class cv4l_buffer;
 public:
     cv4l_queue(v4l_fd *_fd, unsigned type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
                 unsigned memory = V4L2_MEMORY_MMAP)
diff --git a/utils/v4l2-compliance/v4l2-compliance.h
b/utils/v4l2-compliance/v4l2-compliance.h
index f2f7072..b6d4dae 100644
--- a/utils/v4l2-compliance/v4l2-compliance.h
+++ b/utils/v4l2-compliance/v4l2-compliance.h
@@ -137,7 +137,7 @@ static inline int test_ioctl(int fd, unsigned long cmd, ...)
 }

 static inline void *test_mmap(void *start, size_t length, int prot, int flags,
-        int fd, int64_t offset)
+        int fd, off_t offset)
 {
      return wrapper ? v4l2_mmap(start, length, prot, flags, fd, offset) :
         mmap(start, length, prot, flags, fd, offset);
-- 
1.7.9.5


> I also have a small comment below:
>
> On 03/31/2014 04:52 PM, Lad, Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch upgrades the vpif display driver with
>> v4l helpers, this patch does the following,
>>
>> 1: initialize the vb2 queue and context at the time of probe
>> and removes context at remove() callback.
>> 2: uses vb2_ioctl_*() helpers.
>> 3: uses vb2_fop_*() helpers.
>> 4: uses SIMPLE_DEV_PM_OPS.
>> 5: uses vb2_ioctl_*() helpers.
>> 6: vidioc_g/s_priority is now handled by v4l core.
>> 7: removed driver specific fh and now using one provided by v4l.
>> 8: fixes checkpatch warnings.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/davinci/vpif_capture.c |  916 ++++++-------------------
>>  drivers/media/platform/davinci/vpif_capture.h |   32 +-
>>  2 files changed, 229 insertions(+), 719 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
>> index 8dea0b8..76c15b3 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.c
>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>
> ...
>
>>  static int vpif_buffer_init(struct vb2_buffer *vb)
>>  {
>> -     struct vpif_cap_buffer *buf = container_of(vb,
>> -                                     struct vpif_cap_buffer, vb);
>> +     struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
>>
>>       INIT_LIST_HEAD(&buf->list);
>>
>>       return 0;
>>  }
>
> Is this really necessary? I think vpif_buffer_init can just be removed.
> Ditto for vpif_display.c.
>
Yes can be dropped, will remove in next version.

Thanks,
--Prabhakar Lad
