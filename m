Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbaGXL0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaGXL0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:26:51 -0400
Message-ID: <53D0ED70.4070800@redhat.com>
Date: Thu, 24 Jul 2014 13:26:40 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ulrich Obergfell <uobergfe@redhat.com>
CC: Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dzickus@redhat.com, akpm@linux-foundation.org,
        mingo@redhat.com
Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
References: <1406196811-5384-1-git-send-email-drjones@redhat.com> <1406196811-5384-3-git-send-email-drjones@redhat.com> <53D0E3F3.6050206@redhat.com> <1140033921.17233579.1406200685037.JavaMail.zimbra@redhat.com>
In-Reply-To: <1140033921.17233579.1406200685037.JavaMail.zimbra@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/07/2014 13:18, Ulrich Obergfell ha scritto:
>>> >> The running kernel still has the ability to enable/disable at any
>>> >> time with /proc/sys/kernel/nmi_watchdog us usual. However even
>>> >> when the default has been overridden /proc/sys/kernel/nmi_watchdog
>>> >> will initially show '1'. To truly turn it on one must disable/enable
>>> >> it, i.e.
>>> >>   echo 0 > /proc/sys/kernel/nmi_watchdog
>>> >>   echo 1 > /proc/sys/kernel/nmi_watchdog
>> >
>> > Why is it hard to make this show the right value? :)
>> >
>> > Paolo
> 'echo 1 > /proc/sys/kernel/nmi_watchdog' enables both - hard lockup and
> soft lockup detection. watchdog_enable_all_cpus() starts a 'watchdog/N'
> thread for each CPU. If the kernel runs on a bare metal system where the
> processor does not have a PMU, or when perf_event_create_kernel_counter()
> returns failure to watchdog_nmi_enable(), or when the kernel runs as a
> guest on a hypervisor that does not emulate a PMU, then the 'watchdog/N'
> threads are still active for soft lockup detection. Patch 2/3 essentially
> makes watchdog_nmi_enable() behave in the same way as if -ENOENT would
> have been returned by perf_event_create_kernel_counter(). This is then
> reported via a console message.
> 
>   NMI watchdog: disabled (cpu0): hardware events not enabled
> 
> It's hard say what _is_ 'the right value' (because lockup detection is
> then enabled 'partially'), regardless of whether patch 2/3 is applied
> or not.

But this means that it is not possible to re-enable softlockup detection
only.  I think that should be the effect of echo 0 + echo 1, if
hardlockup detection was disabled by either the command line or patch 3.

Paolo
