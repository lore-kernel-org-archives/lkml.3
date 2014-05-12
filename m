Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaELMKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:10:21 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:64836 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaELMKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:10:19 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 12 May 2014 14:09:58 +0200
Message-ID: <CAKgNAkiA23kAFyXQkFV4z0aUE+y5K7AFNwRW+4LqwAyVj=tQtQ@mail.gmail.com>
Subject: SCHED_DEADLINE, sched_getscheduler(), and sched_getparam()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Looking at the code of sched_getparam() and sched_setscheduler() (to
see what might need to land in the man pagea with respect to
SCHED_DEADLINE changes), I see that the former fails (EINVAL) if the
target is a SCHED_DEADLINE process, while the latter succeeds
(returning SCHED_DEADLINE).

The sched_setscheduler() seems fine, but what's the rationale for
having sched_getparam() fail in this case, rather than just returning
a sched_priority of zero (since sched_priority is in any case unused,
as for SCHED_OTHER, right)? My point is that the change seems to
needlessly break applications that employ sched_getparam(). Maybe I am
missing something...

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
