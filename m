Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274Ab3GQXWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:22:36 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44343 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934206Ab3GQXWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <1374097503-25515-1-git-send-email-toshi.kani@hp.com>
References: <1374097503-25515-1-git-send-email-toshi.kani@hp.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 17 Jul 2013 19:22:12 -0400
Message-ID: <CAHGf_=pND-R=qMHg7b=Fi5SqS6ahXJCG865WsOS2eKWa6g3A7A@mail.gmail.com>
Subject: Re: [PATCH] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
To: Toshi Kani <toshi.kani@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        vasilis.liaskovitis@profitbricks.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 5:45 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> CONFIG_ARCH_MEMORY_PROBE enables /sys/devices/system/memory/probe
> interface, which allows a given memory address to be hot-added as
> follows. (See Documentation/memory-hotplug.txt for more detail.)
>
> # echo start_address_of_new_memory > /sys/devices/system/memory/probe
>
> This probe interface is required on powerpc. On x86, however, ACPI
> notifies a memory hotplug event to the kernel, which performs its
> hotplug operation as the result. Therefore, users should not be
> required to use this interface on x86. This probe interface is also
> error-prone that the kernel blindly adds a given memory address
> without checking if the memory is present on the system; no probing
> is done despite of its name. The kernel crashes when a user requests
> to online a memory block that is not present on the system.
>
> This patch disables CONFIG_ARCH_MEMORY_PROBE by default on x86,
> and clarifies it in Documentation/memory-hotplug.txt.

Why don't you completely remove it? Who should use this strange interface?
