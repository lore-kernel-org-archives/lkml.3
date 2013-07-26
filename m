Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab3GZL7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:59:46 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:37094 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3GZL7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:59:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAKb7UvjQYeQjGsw4U_OrBuioF7KdVrBgCNmx5xi3aPXkPsTzaA@mail.gmail.com>
References: <CAKb7UvjQYeQjGsw4U_OrBuioF7KdVrBgCNmx5xi3aPXkPsTzaA@mail.gmail.com>
Date: Fri, 26 Jul 2013 07:59:44 -0400
X-Google-Sender-Auth: crZvvK3RJ21W6eyjDEPB96gm6sg
Message-ID: <CAKb7Uvh+3BXkBjNkbfAQ=ginaoKyJj3+hNKL+WJ0XknAaZd==g@mail.gmail.com>
Subject: Re: 3.11-rc2: panic in __rdmsr_on_cpu
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 6:32 PM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> Hi,
>
> I just built a 3.11-rc2 kernel (+ a few patches, but nothing
> arch-related), and I saw the following: http://i.imgur.com/dCTqOyR.jpg
>
> The rough transcription is
>
> Call Trace:
> <IRQ>
> generic_smp_call_fucntion_single_interrupt
> smp_call_function_single_interrupt
> call_function_single_interrupt
> <EOI>
> ? default_idle
> ? default_idle
> arch_cpu_idle
> cpu_startup_entry
> rest_init
> start_kernel
> ? repair_env_string
> x86_64_start_reservations
> x86_64_start_kernel
> Code: ... cc 81 8b 0f <0f> 32 48 c1 e2 20 89 c0 ...
> RIP: __rdmsr_on_cpu+0x2e/0x44
> Kernel panic - not syncing: Fatal exception in interrupt
>
> A 3.10-rc7 kernel booted just fine. Is this likely a real issue? Or
> perhaps a mis-build of some sort?

FWIW this is repeatable. I did a clean build (make clean && make) and
I still see the same thing. I have a Core i7-920 cpu, not sure what
other information would be relevant. I'd love to avoid a bisect, so
some likely candidates would be most welcome.

Thanks,

  -ilia
