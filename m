Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbaBRK2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:28:09 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45431 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbaBRK2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:28:07 -0500
MIME-Version: 1.0
In-Reply-To: <53017544.90908@huawei.com>
References: <53017544.90908@huawei.com>
Date: Tue, 18 Feb 2014 11:28:06 +0100
Message-ID: <CAOMGZ=Ht22+KuYwmGcJB4gkiu3EpFfj1EFoAF7Mtd7WvjXwJ3A@mail.gmail.com>
Subject: Re: [PATCH V2] mm: add a new command-line kmemcheck value
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Vegard Nossum <vegardno@ifi.uio.no>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 February 2014 03:34, Xishi Qiu <qiuxishi@huawei.com> wrote:
> If we want to debug the kernel memory, we should turn on CONFIG_KMEMCHECK
> and rebuild the kernel. This always takes a long time and sometimes
> impossible, e.g. users don't have the kernel source code or the code
> is different from "www.kernel.org" (private features may be added to the
> kernel, and usually users can not get the whole code).
>
> This patch adds a new command-line "kmemcheck=3", then the kernel will run
> as the same as CONFIG_KMEMCHECK=off even CONFIG_KMEMCHECK is turn on.
> "kmemcheck=0/1/2" is the same as originally. This means we can always turn
> on CONFIG_KMEMCHECK, and use "kmemcheck=3" to control it on/off with out
> rebuild the kernel.
>
> In another word, "kmemcheck=3" is equivalent:
> 1) turn off CONFIG_KMEMCHECK
> 2) rebuild the kernel
> 3) reboot
>
> The different between kmemcheck=0 and 3 is the used memory and nr_cpus.
> Also kmemcheck=0 can used in runtime, and kmemcheck=3 is only used in boot.
> boottime: kmemcheck=0/1/2/3 (command-line)
> runtime: kmemcheck=0/1/2 (/proc/sys/kernel/kmemcheck)

This is not the right way to do what you want.

The behaviour that we want is:

 - CONFIG_KMEMCHECK=y + kmemcheck=0 (boot parameter) should have a
minimal runtime impact and not limit the number of CPUs
 - CONFIG_KMEMCHECK=y + kmemcheck=1 should limit the number of CPUs during boot
 - setting kmemcheck to 1 via /proc/sys/kernel/kmemcheck should
probably return an error if more than 1 CPU is online


Vegard
