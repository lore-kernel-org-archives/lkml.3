Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3EAUxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 16:53:42 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:37901 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab3EAUxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 16:53:40 -0400
Message-ID: <518180CE.1040308@fold.natur.cuni.cz>
Date: Wed, 01 May 2013 22:53:34 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, rafael.j.wysocki@intel.com,
        toshi.kani@hp.com
Subject: linux-3.9: OOPS in intel_timer_pstate_func
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I just this kernel crash on my laptop running fine so far on 3.7.10 (and 3.8.5
if really necessary). The 3.9 was running for maybe 2 hrs, at the most. :(

? cpumask_weight
call_timer_fn.clone
? init_timer_key
run_timer_softirq
? cpumask_weight
__do_softirq
smp_apic_timer_interrupt
apic_timer_interrupt
? cpuidle_wrap_enter
? cpuidle_wrap_enter
cpuidle_enter_tk
cpuidle_enter_state
cpuidle_call
cpu_idel
rest_init
? csum_partial_copy_generic
start_kernel
? repair_env_string
x86_64_start_reservations
x86_64_start_kernel

  I just opened a bug at https://bugzilla.kernel.org/show_bug.cgi?id=57401
with a camera picture of the screen with the stacktrace. I failed to find
a component like CPU or IRQ so please forward this to the appropriate person.
Thank you,
Martin
