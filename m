Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3JWLUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:20:30 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43819 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3JWLU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <20131011051451.GA12193@localhost>
References: <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
	<20131007083505.GA22585@localhost>
	<CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
	<CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
	<20131008020918.GA1220@localhost>
	<20131008021452.GA6456@localhost>
	<20131008080625.GA25034@n2100.arm.linux.org.uk>
	<alpine.DEB.2.00.1310100322040.14436@skynet.skynet.ie>
	<20131010091920.GO25034@n2100.arm.linux.org.uk>
	<20131010105324.GA5105@n2100.arm.linux.org.uk>
	<20131011051451.GA12193@localhost>
Date: Wed, 23 Oct 2013 19:20:24 +0800
Message-ID: <CADJHv_t0PzoxUmfrrss9_korx+Pruig2Xgv8MDbegdviEdx4gA@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Xiong Zhou <jencce.kernel@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How is this going?


regards,


2013/10/11 Fengguang Wu <fengguang.wu@intel.com>:
>> I think something like the below may address the issue - I've only build
>> tested this so far.
>>
>> We have another case where DRM does the wrong thing here too - a similar
>> thing goes on with connectors as well.  I've not yet looked into this,
>> but I'll take a look later today.
>>
>> Fengguang - could you give this some runs through your marvellous test
>> system and see whether it fixes the problem you're seeing please?
>
> Russell, I applied the patch (as commit 17e57131d4c2) on top of
> v3.12-rc4 and here are the test results for the kernels with
>
>         CONFIG_DRM=y
>         CONFIG_DEBUG_KOBJECT_RELEASE=y
>
> As you may see, it's pure improvements. :)
>
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>
>
>
> i386-randconfig-c3-1009
>
> +---------------------------------------------------------------+-----------+--------------+
> |                                                               | v3.12-rc4 | 17e57131d4c2 |
> +---------------------------------------------------------------+-----------+--------------+
> | has_kernel_error_warning                                      | 63        |              |
> | BUG:kernel_early_hang_without_any_printk_output               | 7         |              |
> | WARNING:CPU:PID:at_fs/sysfs/dir.c:sysfs_add_one()             | 56        |              |
> | WARNING:CPU:PID:at_lib/kobject.c:kobject_add_internal()       | 56        |              |
> | WARNING:CPU:PID:at_drivers/base/driver.c:driver_unregister()  | 56        |              |
> | WARNING:CPU:PID:at_lib/debugobjects.c:debug_print_object()    | 56        |              |
> | INFO:trying_to_register_non-static_key                        | 56        |              |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference_at(null) | 56        |              |
> | Oops:PREEMPT_SMP                                              | 56        |              |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt         | 56        |              |
> | BUG:kernel_boot_oops                                          | 56        |              |
> | good_boots                                                    | 0         | 9            |
> +---------------------------------------------------------------+-----------+--------------+
>
> x86_64-randconfig-j5-1009
>
> +------------+-----------+--------------+
> |            | v3.12-rc4 | 17e57131d4c2 |
> +------------+-----------+--------------+
> | good_boots | 30        | 9            |
> +------------+-----------+--------------+
>
> x86_64-randconfig-j3-1009
>
> +---------------------------------------------------------------+-----------+--------------+
> |                                                               | v3.12-rc4 | 17e57131d4c2 |
> +---------------------------------------------------------------+-----------+--------------+
> | has_kernel_error_warning                                      | 60        |              |
> | WARNING:CPU:PID:at_fs/sysfs/dir.c:sysfs_add_one()             | 60        |              |
> | WARNING:CPU:PID:at_lib/kobject.c:kobject_add_internal()       | 60        |              |
> | WARNING:CPU:PID:at_drivers/base/driver.c:driver_unregister()  | 60        |              |
> | WARNING:CPU:PID:at_lib/debugobjects.c:debug_print_object()    | 60        |              |
> | WARNING:CPU:PID:at_arch/x86/kernel/irq_64.c:handle_irq()      | 3         |              |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference_at       | 59        |              |
> | Oops:DEBUG_PAGEALLOC                                          | 28        |              |
> | WARNING:CPU:PID:at_lib/list_debug.c:__list_del_entry()        | 28        |              |
> | BUG:scheduling_while_atomic                                   | 30        |              |
> | INFO:lockdep_is_turned_off                                    | 30        |              |
> | BUG:unable_to_handle_kernel_paging_request_at                 | 55        |              |
> | kernel_BUG_at_kernel/smpboot.c                                | 13        |              |
> | invalid_opcode:DEBUG_PAGEALLOC                                | 13        |              |
> | general_protection_fault:DEBUG_PAGEALLOC                      | 2         |              |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt         | 4         |              |
> | BUG:kernel_boot_oops                                          | 60        |              |
> | WARNING:CPU:PID:at_kernel/workqueue.c:work_fixup_activate()   | 24        |              |
> | WARNING:CPU:PID:at_kernel/workqueue.c:__queue_work()          | 10        |              |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference_at(null) | 2         |              |
> | BUG:unable_to_handle_kernel                                   | 1         |              |
> | BUG:unable_to_handle_kernel_NULL_point                        | 1         |              |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference          | 4         |              |
> | BUG:unable_to_handle_kernel_NULL_pointer_derefe               | 1         |              |
> | BUG:unable_to_handle_kernel_NULL_pointer_de                   | 1         |              |
> | BUG:un                                                        | 1         |              |
> | good_boots                                                    | 0         | 9            |
> +---------------------------------------------------------------+-----------+--------------+
>
> x86_64-randconfig-j1-1009
>
> +-------------------------------------------------+-----------+--------------+
> |                                                 | v3.12-rc4 | 17e57131d4c2 |
> +-------------------------------------------------+-----------+--------------+
> | has_kernel_error_warning                        | 60        | 9            |
> | BUG:kernel_early_hang_without_any_printk_output | 60        | 9            |
> +-------------------------------------------------+-----------+--------------+
>
> x86_64-randconfig-j0-1009
>
> +--------------------------+-----------+--------------+
> |                          | v3.12-rc4 | 17e57131d4c2 |
> +--------------------------+-----------+--------------+
> | good_boots               | 56        | 9            |
> | has_kernel_error_warning | 4         |              |
> | BUG:kernel_test_crashed  | 4         |              |
> +--------------------------+-----------+--------------+
>
> x86_64-randconfig-a2-1009
>
> +------------+-----------+--------------+
> |            | v3.12-rc4 | 17e57131d4c2 |
> +------------+-----------+--------------+
> | good_boots | 3         | 9            |
> +------------+-----------+--------------+
>
> x86_64-randconfig-c9-1009
>
> +------------+-----------+--------------+
> |            | v3.12-rc4 | 17e57131d4c2 |
> +------------+-----------+--------------+
> | good_boots | 33        | 9            |
> +------------+-----------+--------------+
>
> x86_64-randconfig-c3-1009
>
> +-------------------------------------------------+-----------+--------------+
> |                                                 | v3.12-rc4 | 17e57131d4c2 |
> +-------------------------------------------------+-----------+--------------+
> | good_boots                                      | 58        | 8            |
> | has_kernel_error_warning                        | 5         | 1            |
> | BUG:kernel_early_hang_without_any_printk_output | 5         | 1            |
> +-------------------------------------------------+-----------+--------------+
>
> i386-randconfig-r4-1009
>
> +--------------------------------------------------------------+-----------+--------------+
> |                                                              | v3.12-rc4 | 17e57131d4c2 |
> +--------------------------------------------------------------+-----------+--------------+
> | has_kernel_error_warning                                     | 63        |              |
> | WARNING:CPU:PID:at_fs/sysfs/dir.c:sysfs_add_one()            | 63        |              |
> | WARNING:CPU:PID:at_lib/kobject.c:kobject_add_internal()      | 63        |              |
> | WARNING:CPU:PID:at_drivers/base/driver.c:driver_unregister() | 63        |              |
> | WARNING:CPU:PID:at_lib/debugobjects.c:debug_print_object()   | 63        |              |
> | INFO:trying_to_register_non-static_key                       | 63        |              |
> | kernel_BUG_at_kernel/timer.c                                 | 63        |              |
> | invalid_opcode:SMP                                           | 63        |              |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt        | 63        |              |
> | BUG:kernel_boot_oops                                         | 63        |              |
> | good_boots                                                   | 0         | 9            |
> +--------------------------------------------------------------+-----------+--------------+
>
> i386-randconfig-r3-1009
>
> +------------+-----------+--------------+
> |            | v3.12-rc4 | 17e57131d4c2 |
> +------------+-----------+--------------+
> | good_boots | 3         | 9            |
> +------------+-----------+--------------+
>
> i386-randconfig-r1-1009
>
> +-------------------------------------------------+-----------+--------------+
> |                                                 | v3.12-rc4 | 17e57131d4c2 |
> +-------------------------------------------------+-----------+--------------+
> | has_kernel_error_warning                        | 63        | 9            |
> | BUG:kernel_early_hang_without_any_printk_output | 63        | 9            |
> +-------------------------------------------------+-----------+--------------+
>
> i386-randconfig-x2-1009
>
> +------------+-----------+--------------+
> |            | v3.12-rc4 | 17e57131d4c2 |
> +------------+-----------+--------------+
> | good_boots | 3         | 9            |
> +------------+-----------+--------------+
>
> i386-randconfig-i008-1008
>
> +-------------------------------------------------+-----------+--------------+
> |                                                 | v3.12-rc4 | 17e57131d4c2 |
> +-------------------------------------------------+-----------+--------------+
> | has_kernel_error_warning                        | 60        | 9            |
> | BUG:kernel_early_hang_without_any_printk_output | 60        | 9            |
> +-------------------------------------------------+-----------+--------------+
>
> x86_64-randconfig-x1-1009
>
> +---------------------------------------------------------------+-----------+--------------+
> |                                                               | v3.12-rc4 | 17e57131d4c2 |
> +---------------------------------------------------------------+-----------+--------------+
> | has_kernel_error_warning                                      | 63        |              |
> | WARNING:CPU:PID:at_fs/sysfs/dir.c:sysfs_add_one()             | 63        |              |
> | WARNING:CPU:PID:at_lib/kobject.c:kobject_add_internal()       | 63        |              |
> | WARNING:CPU:PID:at_drivers/base/driver.c:driver_unregister()  | 63        |              |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference_at(null) | 63        |              |
> | Oops                                                          | 63        |              |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt         | 63        |              |
> | BUG:kernel_boot_oops                                          | 63        |              |
> | INFO:trying_to_register_non-static_key                        | 2         |              |
> | good_boots                                                    | 0         | 9            |
> +---------------------------------------------------------------+-----------+--------------+
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
