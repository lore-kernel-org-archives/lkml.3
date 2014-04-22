Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbaDVUT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:19:29 -0400
Received: from fujitsu24.fnanic.fujitsu.com ([192.240.6.14]:43523 "EHLO
	fujitsu24.fnanic.fujitsu.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757120AbaDVUT0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:19:26 -0400
From: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
To: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki JP <kosaki.motohiro@jp.fujitsu.com>,
        "gthelen@google.com" <gthelen@google.com>,
        "aswin@hp.com" <aswin@hp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Tue, 22 Apr 2014 13:17:15 -0700
Subject: RE: [PATCH 4/4] ipc/shm.c: Increase the defaults for SHMALL, SHMMAX.
Thread-Topic: [PATCH 4/4] ipc/shm.c: Increase the defaults for SHMALL,
 SHMMAX.
Thread-Index: Ac9dbnUTvQMbe/7bTAyv8Lpx+hrP8AA+VU4g
Message-ID: <6B2BA408B38BA1478B473C31C3D2074E30989E9D84@SV-EXCHANGE1.Corp.FC.LOCAL>
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com>
 <1398090397-2397-2-git-send-email-manfred@colorfullife.com>
 <1398090397-2397-3-git-send-email-manfred@colorfullife.com>
 <1398090397-2397-4-git-send-email-manfred@colorfullife.com>
 <1398090397-2397-5-git-send-email-manfred@colorfullife.com>
In-Reply-To: <1398090397-2397-5-git-send-email-manfred@colorfullife.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-22_07:2014-04-22,2014-04-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Manfred Spraul [mailto:manfred@colorfullife.com]
> Sent: Monday, April 21, 2014 10:27 AM
> To: Davidlohr Bueso; Michael Kerrisk; Martin Schwidefsky
> Cc: LKML; Andrew Morton; KAMEZAWA Hiroyuki; Motohiro Kosaki JP; gthelen@google.com; aswin@hp.com; linux-mm@kvack.org;
> Manfred Spraul
> Subject: [PATCH 4/4] ipc/shm.c: Increase the defaults for SHMALL, SHMMAX.
> 
> System V shared memory
> 
> a) can be abused to trigger out-of-memory conditions and the standard
>    measures against out-of-memory do not work:
> 
>     - it is not possible to use setrlimit to limit the size of shm segments.
> 
>     - segments can exist without association with any processes, thus
>       the oom-killer is unable to free that memory.
> 
> b) is typically used for shared information - today often multiple GB.
>    (e.g. database shared buffers)
> 
> The current default is a maximum segment size of 32 MB and a maximum total size of 8 GB. This is often too much for a) and not
> enough for b), which means that lots of users must change the defaults.
> 
> This patch increases the default limits (nearly) to the maximum, which is perfect for case b). The defaults are used after boot and as
> the initial value for each new namespace.
> 
> Admins/distros that need a protection against a) should reduce the limits and/or enable shm_rmid_forced.
> 
> Further notes:
> - The patch only changes default, overrides behave as before:
>         # sysctl kernel.shmall=33554432
>   would recreate the previous limit for SHMMAX (for the current namespace).
> 
> - Disabling sysv shm allocation is possible with:
>         # sysctl kernel.shmall=0
>   (not a new feature, also per-namespace)
> 
> - The limits are intentionally set to a value slightly less than ULONG_MAX,
>   to avoid triggering overflows in user space apps.
>   [not unreasonable, see http://marc.info/?l=linux-mm&m=139638334330127]
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Reported-by: Davidlohr Bueso <davidlohr@hp.com>
> Cc: mtk.manpages@gmail.com

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
