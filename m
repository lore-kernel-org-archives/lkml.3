Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3LNBSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 20:18:05 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61667 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3LNBSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 20:18:03 -0500
Message-ID: <52ABB1C8.1060406@linaro.org>
Date: Fri, 13 Dec 2013 17:18:00 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH 001/115] gpu: ion: Add ION Memory Manager
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org> <1386973529-4884-2-git-send-email-john.stultz@linaro.org> <20131213235028.GA4919@kroah.com>
In-Reply-To: <20131213235028.GA4919@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------030304040208070307080609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030304040208070307080609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/13/2013 03:50 PM, Greg KH wrote:
> On Fri, Dec 13, 2013 at 02:23:35PM -0800, John Stultz wrote:
>> From: Rebecca Schultz Zavin <rebecca@android.com>
>>
>> Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
>> [jstultz: Squished in Colin Cross' move to staging change]
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> ---
>>  drivers/staging/android/Kconfig                 |    2 +
>>  drivers/staging/android/Makefile                |    2 +
> This patch breaks the build if this option is enabled.
>
> I suggest only adding the driver to the build _after_ it can be built,
> for obvious reasons :)
>
> Other than this "minor" thing, I have no objection to these patches at
> all.  Can you redo this patch to fix this up, and maybe send another
> patch adding it to the build and let me know at what point in the series
> it should be applied?

Ok. Two patches attached.  I ended up just yanking the build directory
since disabling the config option caused trivial collisions in the series.


0001-ion-Disable-ION-as-it-doesn-t-build.patch  - This can be folded in
after the first patch.


0117-ion-Reenable-the-build.patch - This can be applied to the end of
the series, or folded into the last patch "ion: Update system heap
shrinker to use the new count/scan interface"

Let me know if you'd rather this be done some other way.  Also let me
know if you've still not seen the other patches in the series.

thanks
-john


--------------030304040208070307080609
Content-Type: text/x-diff;
 name="0001-ion-Disable-ION-as-it-doesn-t-build.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-ion-Disable-ION-as-it-doesn-t-build.patch"

>From eba11fdcb50d53906f1b159969448803178c173f Mon Sep 17 00:00:00 2001
From: John Stultz <john.stultz@linaro.org>
Date: Fri, 13 Dec 2013 16:56:53 -0800
Subject: [PATCH] ion: Disable ION, as it doesn't build

Since the ion patches are forward ported from 3.10, they
won't build. So disable it from the build for now and we'll
re-enable it after things are building again.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index 0a01e191..29c5ff0 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -1,6 +1,7 @@
 ccflags-y += -I$(src)			# needed for trace events
 
-obj-y					+= ion/
+# ION doesn't build just yet, so disable it from the build
+#obj-y					+= ion/
 
 obj-$(CONFIG_ANDROID_BINDER_IPC)	+= binder.o
 obj-$(CONFIG_ASHMEM)			+= ashmem.o
-- 
1.8.3.2


--------------030304040208070307080609
Content-Type: text/x-diff;
 name="0117-ion-Reenable-the-build.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0117-ion-Reenable-the-build.patch"

>From 60a715a53406a68c399dcf706bdb33c83e9c42ff Mon Sep 17 00:00:00 2001
From: John Stultz <john.stultz@linaro.org>
Date: Fri, 13 Dec 2013 17:12:18 -0800
Subject: [PATCH] ion: Reenable the build

Now that ION builds, reenable it in the build.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index 29c5ff0..0a01e191 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -1,7 +1,6 @@
 ccflags-y += -I$(src)			# needed for trace events
 
-# ION doesn't build just yet, so disable it from the build
-#obj-y					+= ion/
+obj-y					+= ion/
 
 obj-$(CONFIG_ANDROID_BINDER_IPC)	+= binder.o
 obj-$(CONFIG_ASHMEM)			+= ashmem.o
-- 
1.8.3.2


--------------030304040208070307080609--
