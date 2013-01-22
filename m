Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3AVHBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:01:09 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46168 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3AVHBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:01:07 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1358825006.21576.47.camel@gandalf.local.home>
References: <1358825006.21576.47.camel@gandalf.local.home>
Date: Mon, 21 Jan 2013 23:01:06 -0800
Message-ID: <CAOesGMibLJWXmjRtd4u-RBZoQq1swhFYfRD=KYT0cVg2A93Adg@mail.gmail.com>
Subject: Re: [PATCH] powerpc/pasemi: Fix crash on reboot
From: Olof Johansson <olof@lixom.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 21, 2013 at 7:23 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> commit f96972f2dc "kernel/sys.c: call disable_nonboot_cpus() in
> kernel_restart()"
>
> added a call to disable_nonboot_cpus() on kernel_restart(), which tries
> to shutdown all the CPUs except the first one. The issue with the PA
> Semi, is that it does not support CPU hotplug.
>
> When the call is made to __cpu_down(), it calls the notifiers
> CPU_DOWN_PREPARE, and then tries to take the CPU down.
>
> One of the notifiers to the CPU hotplug code, is the cpufreq. The
> DOWN_PREPARE will call __cpufreq_remove_dev() which calls
> cpufreq_driver->exit. The PA Semi exit handler unmaps regions of I/O
> that is used by an interrupt that goes off constantly
> (system_reset_common, but it goes off during normal system operations
> too). I'm not sure exactly what this interrupt does.

On this version of the power architecture, the system comes back
through the reset vector when returning from some of the lower-power
idle states, which should be why you see those exceptions go off.

Thanks for catching this. I have a system that I try booting a few
times every release cycle, but I must have missed checking if reboots
still work. Glad to see you're keeping yours alive, it's becoming a
collectible. :-)

[...]

> Cc: Olof Johansson <olof@lixom.net>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Olof Johansson <olof@lixom.net>

Ben, please apply for 3.8.


-Olof
