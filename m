Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaDXJal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:30:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50863 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbaDXJaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:30:35 -0400
MIME-Version: 1.0
In-Reply-To: <201404240924.s3O9OYCC021688@toshiba.co.jp>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<201404240725.s3O7PrUv003720@toshiba.co.jp>
	<CAKohpokt-O3BAGMzE_=heVBZQOwp0C7eT8ZA2485DgNi3+Xcqg@mail.gmail.com>
	<201404240832.s3O8WHd0011014@toshiba.co.jp>
	<CAKohpokk4rGeP3QfVT5_HBO4pc=22yPBLV78D++y1Ab72y1OJQ@mail.gmail.com>
	<201404240924.s3O9OYCC021688@toshiba.co.jp>
Date: Thu, 24 Apr 2014 15:00:34 +0530
Message-ID: <CAKohponA4-cm2_FB=8R8aVEWNhtUfOUebcfzn7W+XR0zKHCtxw@mail.gmail.com>
Subject: Re: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 April 2014 14:54, Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp> wrote:
> Why didn't you just apply the patch on top of your tree so that the
> information included in the git commit (e.g: my name and mail) remains?
>
> This part:
>
> cpuset: quiesce: change irq disable/enable by irq save/restore
>
> The function __migrate_timers can be called under interrupt context
> or thread context depending on the core where the system call was
> executed. In case it executes under interrupt context, it
> seems a bad idea to leave interrupts enabled after migrating the
> timers. In fact, this caused kernel errors on the ARM architecture and
> on the x86_64 architecture with the 3.10 kernel (backported version
> of the cpuset-quiesce patch).
>
> Signed-off-by: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
> Signed-off-by: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>

That's what I told you earlier when I said this:

> I can't keep it as a separate patch and so would be required to merge
> it into my original patch..

And the reason being: "No patch is supposed to break things, otherwise
git bisect wouldn't work smoothly".. And so git bisect would complain
this issue after my patch and so I have to merge the fixes you gave into
the original patch as its not yet merged.
