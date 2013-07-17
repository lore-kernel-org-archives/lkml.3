Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965189Ab3GQXaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:30:39 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:8755 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934028Ab3GQXaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:30:35 -0400
Message-ID: <1374103783.24916.49.camel@misato.fc.hp.com>
Subject: Re: [PATCH] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
From: Toshi Kani <toshi.kani@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        vasilis.liaskovitis@profitbricks.com
Date: Wed, 17 Jul 2013 17:29:43 -0600
In-Reply-To: <CAHGf_=pND-R=qMHg7b=Fi5SqS6ahXJCG865WsOS2eKWa6g3A7A@mail.gmail.com>
References: <1374097503-25515-1-git-send-email-toshi.kani@hp.com>
	 <CAHGf_=pND-R=qMHg7b=Fi5SqS6ahXJCG865WsOS2eKWa6g3A7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 19:22 -0400, KOSAKI Motohiro wrote:
> On Wed, Jul 17, 2013 at 5:45 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> > CONFIG_ARCH_MEMORY_PROBE enables /sys/devices/system/memory/probe
> > interface, which allows a given memory address to be hot-added as
> > follows. (See Documentation/memory-hotplug.txt for more detail.)
> >
> > # echo start_address_of_new_memory > /sys/devices/system/memory/probe
> >
> > This probe interface is required on powerpc. On x86, however, ACPI
> > notifies a memory hotplug event to the kernel, which performs its
> > hotplug operation as the result. Therefore, users should not be
> > required to use this interface on x86. This probe interface is also
> > error-prone that the kernel blindly adds a given memory address
> > without checking if the memory is present on the system; no probing
> > is done despite of its name. The kernel crashes when a user requests
> > to online a memory block that is not present on the system.
> >
> > This patch disables CONFIG_ARCH_MEMORY_PROBE by default on x86,
> > and clarifies it in Documentation/memory-hotplug.txt.
> 
> Why don't you completely remove it? Who should use this strange interface?

According to the comment below, this probe interface is used on powerpc.
So, we cannot remove it, but to disable it on x86.

/*
 * Some architectures will have custom drivers to do this, and
 * will not need to do it from userspace.  The fake hot-add code
 * as well as ppc64 will do all of their discovery in userspace
 * and will require this interface.
 */
#ifdef CONFIG_ARCH_MEMORY_PROBE
static ssize_t
memory_probe_store(struct device *dev, struct device_attribute *attr,
                   const char *buf, size_t count)
{
	:

Thanks,
-Toshi

