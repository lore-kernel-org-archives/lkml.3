Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935779Ab3DILyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:54:37 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:64951 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933969Ab3DILyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:54:36 -0400
MIME-Version: 1.0
Date: Tue, 9 Apr 2013 14:54:34 +0300
X-Google-Sender-Auth: YXCSGRNpUdq5zfA3l2FX4TqnMvA
Message-ID: <CACraW2rBMfXL_M13DD-qLvmZj55XPykEW-5qcVwViWg9XM00fA@mail.gmail.com>
Subject: Re: Re: drm/i915: new warning (regression) in 3.7.10 and 3.8.3
From: Tomas Melin <tomas.melin@iki.fi>
To: daniel.vetter@ffwll.ch
Cc: richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013 09:32:51 +0100, Daniel Vetter wrote:
>
> On Sat, Mar 16, 2013 at 01:28:50PM +0100, Richard Cochran wrote:
>>
>> I have an Acer Aspire One netbook, and on it I get the following
>> warning when closing and opening the lid. I think this warning first
>> appeared in 3.7.
>>
>> Does this need fixing? If so, who can do it?
>
> Another pesky BIOS which changes the display state behind our back on lid
> closing! Should be duct-tapped over with
>
> commit 45e2b5f640b3766da3eda48f6c35f088155c06f3
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Fri Nov 23 18:16:34 2012 +0100
>
>     drm/i915: force restore on lid open
>
> which is in 3.8.

I'm seeing the same problems on my eeepc using 3.8. Happens (most) of
the time when opening and closing the lid. Any ideas on how to fix
this?

-Tomas

[20314.679749] [drm:i9xx_crtc_mode_set] *ERROR* Couldn't find PLL
settings for mode!

[20314.679787] ------------[ cut here ]------------
[20314.679819] WARNING: at drivers/gpu/drm/i915/intel_display.c:7864
intel_modeset_check_state+0x4ad/0x620()
[20314.679831] Hardware name: 901
[20314.679843] encoder's hw state doesn't match sw tracking (expected
1, found 0)
[20314.679853] Modules linked in: bridge ipv6 rfcomm fuse btusb
rt2800pci rt2800lib rt2x00pci rt2x00lib atl1e
[20314.679917] Pid: 10069, comm: kworker/0:0 Tainted: G        W    3.8.0 #8
[20314.679930] Call Trace:
[20314.679958]  [<c1033d6d>] warn_slowpath_common+0x6d/0xa0
[20314.679983]  [<c136645d>] ? intel_modeset_check_state+0x4ad/0x620
[20314.680006]  [<c136645d>] ? intel_modeset_check_state+0x4ad/0x620
[20314.680017]  [<c1033e1e>] warn_slowpath_fmt+0x2e/0x30
[20314.680017]  [<c136645d>] intel_modeset_check_state+0x4ad/0x620
[20314.680103]  [<c1366d31>] intel_set_mode+0x701/0x990
[20314.680170]  [<c13695c5>] intel_modeset_setup_hw_state+0x5d5/0x8e0
[20314.680215]  [<c12e3798>] ? acpi_lid_open+0x28/0x40
[20314.680236]  [<c136b6db>] intel_lid_notify+0x9b/0xc0
[20314.680258]  [<c1731ad5>] notifier_call_chain+0x45/0x60
[20314.680283]  [<c1057f4e>] __blocking_notifier_call_chain+0x3e/0x60
[20314.680306]  [<c1057f8a>] blocking_notifier_call_chain+0x1a/0x20
[20314.680329]  [<c12e3839>] acpi_lid_send_state+0x78/0x9d
[20314.680351]  [<c12e38aa>] acpi_button_notify+0x30/0xa4
[20314.680376]  [<c12c435e>] acpi_device_notify+0x12/0x15
[20314.680402]  [<c12cf786>] acpi_ev_notify_dispatch+0x2e/0x45
[20314.680424]  [<c12c14cb>] acpi_os_execute_deferred+0x1b/0x26
[20314.680449]  [<c104c800>] process_one_work+0x110/0x380
[20314.680475]  [<c172ede9>] ? apic_timer_interrupt+0x2d/0x34
[20314.680498]  [<c12c14b0>] ? acpi_os_wait_events_complete+0x19/0x19
[20314.680522]  [<c104df89>] worker_thread+0x119/0x340
[20314.680545]  [<c104de70>] ? manage_workers+0x260/0x260
[20314.680572]  [<c10522af>] kthread+0x8f/0xa0
[20314.680598]  [<c1734fb7>] ret_from_kernel_thread+0x1b/0x28
[20314.680622]  [<c1052220>] ? flush_kthread_work+0xc0/0xc0
[20314.680640] ---[ end trace 037b36714b28cbdf ]---
[20314.680661] ------------[ cut here ]------------
[20314.680684] WARNING: at drivers/gpu/drm/i915/intel_display.c:7898
intel_modeset_check_state+0x47b/0x620()
[20314.680697] Hardware name: 901
[20314.680709] crtc's computed active state doesn't match tracked
active state (expected 1, found 0)
[20314.680719] Modules linked in: bridge ipv6 rfcomm fuse btusb
rt2800pci rt2800lib rt2x00pci rt2x00lib atl1e
[20314.680898] Pid: 10069, comm: kworker/0:0 Tainted: G        W    3.8.0 #8
[20314.680910] Call Trace:
[20314.680934]  [<c1033d6d>] warn_slowpath_common+0x6d/0xa0
[20314.680960]  [<c136642b>] ? intel_modeset_check_state+0x47b/0x620
[20314.680983]  [<c136642b>] ? intel_modeset_check_state+0x47b/0x620
[20314.681006]  [<c1033e1e>] warn_slowpath_fmt+0x2e/0x30
[20314.681041]  [<c136642b>] intel_modeset_check_state+0x47b/0x620
[20314.681052]  [<c1366d31>] intel_set_mode+0x701/0x990
[20314.681095]  [<c13695c5>] intel_modeset_setup_hw_state+0x5d5/0x8e0
[20314.681122]  [<c12e3798>] ? acpi_lid_open+0x28/0x40
[20314.681147]  [<c136b6db>] intel_lid_notify+0x9b/0xc0
[20314.681170]  [<c1731ad5>] notifier_call_chain+0x45/0x60
[20314.681196]  [<c1057f4e>] __blocking_notifier_call_chain+0x3e/0x60
[20314.681221]  [<c1057f8a>] blocking_notifier_call_chain+0x1a/0x20
[20314.681246]  [<c12e3839>] acpi_lid_send_state+0x78/0x9d
[20314.681270]  [<c12e38aa>] acpi_button_notify+0x30/0xa4
[20314.681295]  [<c12c435e>] acpi_device_notify+0x12/0x15
[20314.681320]  [<c12cf786>] acpi_ev_notify_dispatch+0x2e/0x45
[20314.681344]  [<c12c14cb>] acpi_os_execute_deferred+0x1b/0x26
[20314.681366]  [<c104c800>] process_one_work+0x110/0x380
[20314.681392]  [<c172ede9>] ? apic_timer_interrupt+0x2d/0x34
[20314.681416]  [<c12c14b0>] ? acpi_os_wait_events_complete+0x19/0x19
[20314.681465]  [<c104df89>] worker_thread+0x119/0x340
[20314.681516]  [<c104de70>] ? manage_workers+0x260/0x260
[20314.681568]  [<c10522af>] kthread+0x8f/0xa0
[20314.681614]  [<c1734fb7>] ret_from_kernel_thread+0x1b/0x28
[20314.681660]  [<c1052220>] ? flush_kthread_work+0xc0/0xc0
[20314.681681] ---[ end trace 037b36714b28cbe0 ]---
