Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3JZQic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 12:38:32 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:43823 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3JZQib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 12:38:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAG5DWoj_5cQmQUtd+784sQNW7RhfXUWivP8cbOpADiS1Li35Fg@mail.gmail.com>
References: <CAG5DWoj_5cQmQUtd+784sQNW7RhfXUWivP8cbOpADiS1Li35Fg@mail.gmail.com>
Date: Sat, 26 Oct 2013 20:38:30 +0400
Message-ID: <CAG5DWoj9nnoJzCtBfWrTyx-GNzXqgL3So-MG+ZcsH4j8jnfefw@mail.gmail.com>
Subject: Re: kprobe: "BUG: unable to handle kernel paging request"
From: Azat Khuzhin <a3at.mail@gmail.com>
To: open list <linux-kernel@vger.kernel.org>
Cc: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 1:01 AM, Azat Khuzhin <a3at.mail@gmail.com> wrote:
> With some kernel's configuration there is such messages in dmesg in
> different places while using kprobes.
>
> I investigated this and founded that it reproduced with
> https://gist.github.com/azat/7078890#file-config-3-12-0-rc5-deb
> And not reproduced with
> https://gist.github.com/azat/7078890#file-config-3-12-0-rc5-worked-kprobe

I reduced difference between this two configs,
and the new one with not worked kprobe is here:
https://gist.github.com/azat/7078890#file-config-3-12-0-rc5-dont-worked-kprobe

The only thing I changed in "make menuconfig" is preemption model,
from CONFIG_PREEMPT_VOLUNTARY(good) to CONFIG_PREEMPT(bad)

U=https://gist.github.com/azat/7078890/raw/
diff -u0 <(curl -s
$U/8268502680c9b1c5924ce6bf45dd08381bc9ddb3/config-3.12.0-rc5%2Bdont-worked-kprobe)
<(curl -s $U/b7a9367506fa1c9598f5752c045cff582c3588ba/config-3.12.0-rc5%2Bworked-kprobe)

--- /dev/fd/63  2013-10-26 20:35:00.679801733 +0400
+++ /dev/fd/62  2013-10-26 20:35:00.679801733 +0400
@@ -128,2 +128,2 @@
-CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_PREEMPT_RCU=y
+CONFIG_TREE_RCU=y
+# CONFIG_PREEMPT_RCU is not set
@@ -137 +136,0 @@
-# CONFIG_RCU_BOOST is not set
@@ -224,0 +224 @@
+CONFIG_OPTPROBES=y
@@ -332 +332,5 @@
-CONFIG_UNINLINE_SPIN_UNLOCK=y
+CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
+CONFIG_INLINE_READ_UNLOCK=y
+CONFIG_INLINE_READ_UNLOCK_IRQ=y
+CONFIG_INLINE_WRITE_UNLOCK=y
+CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
@@ -378,2 +382,2 @@
-# CONFIG_PREEMPT_VOLUNTARY is not set
-CONFIG_PREEMPT=y
+CONFIG_PREEMPT_VOLUNTARY=y
+# CONFIG_PREEMPT is not set
@@ -3547,0 +3552 @@
+# CONFIG_DRM_I810 is not set
@@ -5047 +5051,0 @@
-CONFIG_DEBUG_PREEMPT=y
@@ -5075 +5078,0 @@
-# CONFIG_PROVE_RCU_DELAY is not set
@@ -5079 +5081,0 @@
-CONFIG_RCU_CPU_STALL_VERBOSE=y
@@ -5111 +5112,0 @@
-# CONFIG_PREEMPT_TRACER is not set

>
> I used the next script for testing
> https://gist.github.com/azat/7078890#file-ktap-sh
>
> Here is the initial email log with Jovi (ktap author):
> http://www.freelists.org/post/ktap/BUG-unable-to-handle-kernel-paging-request-after-ktap-script-to-trace-SyS-write
>
> If I can help, please let me know!
> Thanks!
>
> --
> Respectfully
> Azat Khuzhin



-- 
Respectfully
Azat Khuzhin
