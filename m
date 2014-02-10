Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaBJGjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 01:39:03 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:59939 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaBJGjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 01:39:01 -0500
MIME-Version: 1.0
In-Reply-To: <1392012424.3178.23.camel@joe-AO722>
References: <81912500.jvGoQpGOq5@daeseok-laptop.cloud.net>
	<1392012424.3178.23.camel@joe-AO722>
Date: Mon, 10 Feb 2014 15:39:00 +0900
Message-ID: <CAHb8M2BnapKZpfCuJwMvLqUvPQh8=VRX8Cv2GCtTC3_VOSMeqQ@mail.gmail.com>
Subject: Re: [PATCH] staging : ion : Fix some checkpatch warnings and an error
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Zavin <rebecca@android.com>, ccross@android.com,
        ohaugan@codeaurora.org, Rom Lemarchand <romlem@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think It looks better than reported by checkpatch.pl.

But I have a qeustion, if your patch is applied to checkpatch.pl file,
a return type of "void *" line will be changed.
for example,
void * (*map_kernel)(struct ion_heap *heap, struct ion_buffer *buffer);
=> void *(*map_kernel)(struct ion_heap *heap, struct ion_buffer
*buffer); in same file.
right?

If you confirm my question, I re-send my patch after fixing that line.

And I have a patch which is same fix. (driver/staging/android/sync.h)

diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 62e2255b..6ee8d69 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -53,7 +53,7 @@ struct sync_timeline_ops {
    const char *driver_name;

    /* required */
-   struct sync_pt *(*dup)(struct sync_pt *pt);
+   struct sync_pt * (*dup)(struct sync_pt *pt);

    /* required */
    int (*has_signaled)(struct sync_pt *pt);

2014-02-10 15:07 GMT+09:00 Joe Perches <joe@perches.com>:
> On Mon, 2014-02-10 at 14:56 +0900, Daeseok Youn wrote:
>>
>
> Hello.
>
>> diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
> []
>> -     struct sg_table *(*map_dma) (struct ion_heap *heap,
>> +     struct sg_table * (*map_dma)(struct ion_heap *heap,
>
> The message about space required after "struct sg_table *"
> is a checkpatch defect.  This is better as:
>
>         struct sg_table *(*map_dma)(struct ion_heap *heap, etc...)
>
> I'll fix checkpatch in a little bit.
>
>
