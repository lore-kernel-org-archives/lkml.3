Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3LPJIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:08:41 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:36411 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3LPJIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:08:38 -0500
MIME-Version: 1.0
In-Reply-To: <20131208172508.0cacabd0@tor.valhalla.alchemy.lu>
References: <20131208172508.0cacabd0@tor.valhalla.alchemy.lu>
Date: Mon, 16 Dec 2013 14:38:37 +0530
Message-ID: <CAKohpom+xmPfpAa6qeNq+mghknrxj03B+-=Vtqj-7iR-OgOv6A@mail.gmail.com>
Subject: Re: Problem: Possible regression in intel_pstate on 3.12
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Joakim Hernberg <jbh@alchemy.lu>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Dirk in cc..

On 8 December 2013 21:55, Joakim Hernberg <jbh@alchemy.lu> wrote:
> When I'm running KDE on linux 3.12 (archlinux) my intel i7-2600k seems
> to no longer reduce the cpu multiplier and thus runs hotter than under
> linux 3.11.  i7z shows the cpu as being close to idle and using C0 to
> C6 states.
>
> On "Linux version 3.12.3-1-ARCH (tobias@T-POWA-LX) (gcc version 4.8.2
> (GCC) ) #1 SMP PREEMPT Wed Dec 4 21:45:42 CET 2013"
>
> Output of # cpupower frequency-list when booted to the command prompt:
>
> analyzing CPU 0:
>   driver: intel_pstate
>   CPUs which run at the same hardware frequency: 0
>   CPUs which need to have their frequency coordinated by software: 0
>   maximum transition latency: 0.97 ms.
>   hardware limits: 1.60 GHz - 5.90 GHz
>   available cpufreq governors: performance, powersave
>   current policy: frequency should be within 1.60 GHz and 5.90 GHz.
>                   The governor "powersave" may decide which speed to use
>                   within this range.
>   current CPU frequency is 1.69 GHz (asserted by call to hardware).
>   boost state support:
>     Supported: yes
>     Active: yes
>     25500 MHz max turbo 4 active cores
>     25500 MHz max turbo 3 active cores
>     25500 MHz max turbo 2 active cores
>     25500 MHz max turbo 1 active cores
>
> When booted into KDE and system more or less idle:
>
> analyzing CPU 0:
>   driver: intel_pstate
>   CPUs which run at the same hardware frequency: 0
>   CPUs which need to have their frequency coordinated by software: 0
>   maximum transition latency: 0.97 ms.
>   hardware limits: 1.60 GHz - 5.90 GHz
>   available cpufreq governors: performance, powersave
>   current policy: frequency should be within 1.60 GHz and 5.90 GHz.
>                   The governor "powersave" may decide which speed to use
>                   within this range.
>   current CPU frequency is 4.30 GHz (asserted by call to hardware).
>   boost state support:
>     Supported: yes
>     Active: yes
>     25500 MHz max turbo 4 active cores
>     25500 MHz max turbo 3 active cores
>     25500 MHz max turbo 2 active cores
>     25500 MHz max turbo 1 active cores
>
> Output of top while in KDE:
>
> top - 14:21:13 up 9 min, 16 users,  load average: 0.48, 0.88, 0.59
> Tasks: 205 total,   1 running, 204 sleeping,   0 stopped,   0 zombie
> %Cpu(s):  1.2 us,  0.4 sy,  0.0 ni, 98.1 id,  0.3 wa,  0.0 hi,  0.0
> si,  0.0 st KiB Mem:  15366248 total,  2435540 used, 12930708 free,
> 71804 buffers KiB Swap:  4193276 total,        0 used,  4193276 free,
> 1135904 cached
>
>
>
> On "Linux version 3.11.6-1-ARCH
> (nobody@var-lib-archbuild-extra-x86_64-thomas) (gcc version 4.8.1
> 20130725 (prerelease) (GCC) ) #1 SMP PREEMPT Fri Oct 18 23:22:36 CEST
> 2013"
>
> Output of cpupower frequency-list while in KDE:
>
> analyzing CPU 0:
>   driver: intel_pstate
>   CPUs which run at the same hardware frequency: 0
>   CPUs which need to have their frequency coordinated by software: 0
>   maximum transition latency: 0.97 ms.
>   hardware limits: 1.60 GHz - 5.90 GHz
>   available cpufreq governors: performance, powersave
>   current policy: frequency should be within 1.60 GHz and 5.90 GHz.
>                   The governor "powersave" may decide which speed to use
>                   within this range.
>   current CPU frequency is 1.94 GHz (asserted by call to hardware).
>   boost state support:
>     Supported: yes
>     Active: yes
>     25500 MHz max turbo 4 active cores
>     25500 MHz max turbo 3 active cores
>     25500 MHz max turbo 2 active cores
>     25500 MHz max turbo 1 active cores
>
> I'm attaching the config files of both kernels in case it's simply a
> configuration pebcak.
>
> --
>
>    Joakim
