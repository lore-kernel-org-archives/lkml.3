Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaEFUGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:06:52 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:31467 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaEFUGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:06:50 -0400
Message-ID: <1399406800.13799.20.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] ipc/shm.c: increase the limits for SHMMAX, SHMALL
From: Davidlohr Bueso <davidlohr@hp.com>
To: mtk.manpages@gmail.com
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, aswin@hp.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Tue, 06 May 2014 13:06:40 -0700
In-Reply-To: <CAKgNAkjuU68hgyMOVGBVoBTOhhGdBytQh6H0ExiLoXfujKyP_w@mail.gmail.com>
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com>
	 <CAKgNAkjuU68hgyMOVGBVoBTOhhGdBytQh6H0ExiLoXfujKyP_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 15:16 +0200, Michael Kerrisk (man-pages) wrote:
> Hi Manfred,
> 
> On Mon, Apr 21, 2014 at 4:26 PM, Manfred Spraul
> <manfred@colorfullife.com> wrote:
> > Hi all,
> >
> > the increase of SHMMAX/SHMALL is now a 4 patch series.
> > I don't have ideas how to improve it further.
> 
> On the assumption that your patches are heading to mainline, could you
> send me a man-pages patch for the changes?

Btw, I think that the code could still use some love wrt documentation.
Andrew, please consider this for -next if folks agree. Thanks.

8<----------------------------------------------------------

From: Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH] ipc,shm: document new limits in the uapi header

This is useful in the future and allows users to
better understand the reasoning behind the changes.

Also use UL as we're dealing with it anyways.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/uapi/linux/shm.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/shm.h b/include/uapi/linux/shm.h
index 74e786d..e37fb08 100644
--- a/include/uapi/linux/shm.h
+++ b/include/uapi/linux/shm.h
@@ -8,17 +8,19 @@
 #endif
 
 /*
- * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
- * be modified by sysctl.
+ * SHMMNI, SHMMAX and SHMALL are the default upper limits which can be
+ * modified by sysctl. Both SHMMAX and SHMALL have their default values
+ * to the maximum limit which is as large as it can be without helping
+ * userspace overflow the values. There is really nothing the kernel
+ * can do to avoid this any variables. It is therefore not advised to
+ * make them any larger. This is suitable for both 32 and 64-bit systems.
  */
-
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
-#define SHMMAX (ULONG_MAX - (1L<<24))	 /* max shared seg size (bytes) */
-#define SHMALL (ULONG_MAX - (1L<<24))	 /* max shm system wide (pages) */
+#define SHMMAX (ULONG_MAX - (1UL << 24)) /* max shared seg size (bytes) */
+#define SHMALL (ULONG_MAX - (1UL << 24)) /* max shm system wide (pages) */
 #define SHMSEG SHMMNI			 /* max shared segs per process */
 
-
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct shmid_ds {
 	struct ipc_perm		shm_perm;	/* operation perms */
-- 
1.8.1.4



