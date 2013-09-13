Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3IMIj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:39:59 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:34338 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755912Ab3IMIjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:39:55 -0400
Message-ID: <5232CF56.8060605@vmware.com>
Date: Fri, 13 Sep 2013 10:39:50 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] completely bonkers use of set_need_resched + VM_FAULT_NOPAGE
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net> <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <5231E18D.7070306@canonical.com> <5231EF5A.7010901@vmware.com> <52323734.4070908@canonical.com> <5232B44C.9010408@vmware.com> <5232BBE1.5030509@canonical.com> <5232C2BB.9070303@vmware.com> <5232C3E8.2050501@canonical.com> <5232CB66.6000906@vmware.com> <CAKMK7uFkav0b+8AYkm_3eT=d6T6wvstHuOXkTwFt_Do4YmijQA@mail.gmail.com>
In-Reply-To: <CAKMK7uFkav0b+8AYkm_3eT=d6T6wvstHuOXkTwFt_Do4YmijQA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 10:32 AM, Daniel Vetter wrote:
> On Fri, Sep 13, 2013 at 10:23 AM, Thomas Hellstrom
> <thellstrom@vmware.com> wrote:
>> As previously mentioned, copy_from_user should return -EFAULT, since the
>> VMAs are marked with VM_IO. It should not recurse into fault(), so evil
>> user-space looses.
> I haven't put a printk in the code to prove this, but gem mmap also
> sets VM_IO in drm_gem_mmap_obj. And we can very much hit our own fault
> handler and deadlock ....

If this is indeed true, I guess I need to accept the fact that my 
solution is bad.
(and worse I can't blame not having my morning coffee).

I'll take a deeper look.
/Thomas
