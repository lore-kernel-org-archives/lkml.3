Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaBUV1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:27:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaBUV1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:27:09 -0500
Date: Fri, 21 Feb 2014 13:27:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Jianguo Wu <wujianguo@huawei.com>,
        Andy Honig <ahonig@google.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] x86, kaslr: randomize module base load address
Message-Id: <20140221132708.52054104059b785080c76e3b@linux-foundation.org>
In-Reply-To: <5307C2A2.5010006@zytor.com>
References: <20140221202110.GA29885@www.outflux.net>
	<20140221123658.5752f75eea6506d17bfa313b@linux-foundation.org>
	<CAGXu5jLGBJp7oKXjausV70bXF-RTVDXxdZriS0cJ7X6NO90Ybg@mail.gmail.com>
	<20140221131531.2db80023c59895a930cf374f@linux-foundation.org>
	<5307C2A2.5010006@zytor.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 13:18:26 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/21/2014 01:15 PM, Andrew Morton wrote:
> >>
> >> I've been slapped down for adding more config options in the past, and
> >> I think it's unlikely that people using CONFIG_RANDOMIZE_BASE won't
> >> want the modules base randomized too. I think this is a safe default,
> >> but if you see it as a requirement, I can change it.
> > 
> > I think there were issues with some embedded systems where it's
> > hard/impossible to provide/alter boot parameters.
> > 
> 
> We now allow kernel parameters to be compiled into the kernel image for
> that reason.

We do?  What's that Kconfig variable called?

We have a few (inconsistently named) things like

CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1

which presumably become obsolete with a general
feed-this-string-to-the-kernel feature?

