Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbaE2Ftv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:49:51 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:36811 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571AbaE2Ftu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 01:49:50 -0400
MIME-Version: 1.0
Date: Wed, 28 May 2014 22:49:49 -0700
Message-ID: <CAPD3YnMZS=2UUJNgh1JBE5qQQinXyKsd0xx2+_Z8gSc4gcWGGw@mail.gmail.com>
Subject: kdump kernel with SMP
From: Luong Ngo <luong.ngo@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I need advises with a problem of kdump kernel in SMP machine. The
problem I see is when panic happens, if the panic occurs on core 0,
kdump kernel would receive interrups, specifically the sata disk
driver works fine, but if panic happens on any other core, kdump
kernel seems to not get any interrupt. I add boot parameter to dump
local APIC and IO APIC and it looks like all interrupts has the
destination is APIC ID 0, which I believe means core 0, while local
APIC has a different APIC ID. So I start looking around the kernel and
find  a function call smp_processor_id() that seems to always return 0
regardless what core is running. This return value ultimately
determines the structure cpu_online_map that is returned by
apic->target_cpus() inside IO APIC setup code.  That is what I believe
is happening but not sure if what I understand is right or missing
something here?
I tried boot parameter max_irqs=0 and interrupts seem to work but I
know that would disable SMP and IO APIC. Can kdump kernel be in SMP
mode? Why does smp_processor_id returns 0 even though the core that
panics is non 0, which cause IO APIC to be programmed with all dest
APIC ID to be 0?

Thanks a lot for your help.
Regards,
Luong
