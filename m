Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3JHFbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:31:53 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55171 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3JHFbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:31:50 -0400
MIME-Version: 1.0
In-Reply-To: <20131008044706.GA11725@localhost>
References: <20131008044706.GA11725@localhost>
Date: Mon, 7 Oct 2013 22:31:49 -0700
X-Google-Sender-Auth: 8kj9a7VkPb6lUNWbw6sdI1W80wQ
Message-ID: <CAGXu5jLtx9AfURmVitfeDRKHBkj5X3xSa+6hsyG9uwCqQuzqUQ@mail.gmail.com>
Subject: Re: [x86, kaslr] BUG: kernel early hang without any printk output
From: Kees Cook <keescook@chromium.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 9:47 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is
>
> commit 10fe632a9c6b9ade004c8b0c2ea2c3c562d24f18
> Author: Kees Cook <keescook@chromium.org>
> Date:   Thu Apr 25 14:20:25 2013 -0700
>
>     x86, kaslr: find minimum safe relocation position
>
>     Examine all the known unsafe areas and avoid them by just raising the
>     minimum relocation position to be past them.
>
>     Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-i005-1008/kees:kaslr-c-v6/.vmlinuz-544c3c7c7c7a22deabefbdd4b42675924bcc7afa-20131008114452-8-inn branch=kees/kaslr-c-v6 BOOT_IMAGE=/kernel/i386-randconfig-i005-1008/544c3c7c7c7a22deabefbdd4b42675924bcc7afa/vmlinuz-3.12.0-rc4-00027-g544c3c7

Thanks! Yeah, the -v6 of this series had some problems. I've removed
the old versions from my tree now. -v8 should behave better, though
it's still being worked on.

-Kees

-- 
Kees Cook
Chrome OS Security
