Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3ILTsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:48:24 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34976 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3ILTsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:48:22 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <5231EF5A.7010901@vmware.com>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
	<CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
	<5231E18D.7070306@canonical.com>
	<5231EF5A.7010901@vmware.com>
Date: Thu, 12 Sep 2013 21:48:22 +0200
Message-ID: <CAKMK7uHLLseg_Aqiq9PoBNdnL_aC7A6sJYK6xYddi1FdQfKNsw@mail.gmail.com>
Subject: Re: [BUG] completely bonkers use of set_need_resched + VM_FAULT_NOPAGE
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 6:44 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>
> I think a possible fix would be if fault() were allowed to return an error
> and drop the mmap_sem() before returning.
>
> Otherwise we need to track down all copy_to_user / copy_from_user which
> happen with bo::reserve held.

For maximal evilness submit the relocation list (or whatever data
execbuf slurps in with copy_from_user while holding bo::reserve) of a
bo in the execbuf list. At least that's the testcase we have for
drm/i915. Then make sure that the execbuf wants the bo somewhere it
can't be mmaped from userspace, so needs to be moved both in the fault
handler and then back for the execbuf to continue ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
