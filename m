Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3GYWdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:33:00 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58217 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3GYWc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:32:58 -0400
MIME-Version: 1.0
Date: Thu, 25 Jul 2013 18:32:57 -0400
X-Google-Sender-Auth: HPdZVIRxVLPowTaokB8V7vjukpM
Message-ID: <CAKb7UvjQYeQjGsw4U_OrBuioF7KdVrBgCNmx5xi3aPXkPsTzaA@mail.gmail.com>
Subject: 3.11-rc2: panic in __rdmsr_on_cpu
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just built a 3.11-rc2 kernel (+ a few patches, but nothing
arch-related), and I saw the following: http://i.imgur.com/dCTqOyR.jpg

The rough transcription is

Call Trace:
<IRQ>
generic_smp_call_fucntion_single_interrupt
smp_call_function_single_interrupt
call_function_single_interrupt
<EOI>
? default_idle
? default_idle
arch_cpu_idle
cpu_startup_entry
rest_init
start_kernel
? repair_env_string
x86_64_start_reservations
x86_64_start_kernel
Code: ... cc 81 8b 0f <0f> 32 48 c1 e2 20 89 c0 ...
RIP: __rdmsr_on_cpu+0x2e/0x44
Kernel panic - not syncing: Fatal exception in interrupt

A 3.10-rc7 kernel booted just fine. Is this likely a real issue? Or
perhaps a mis-build of some sort?

Thanks for any advice,

  -ilia
