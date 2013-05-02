Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab3EBKnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:43:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:39120 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab3EBKnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:43:20 -0400
Date: Thu, 2 May 2013 12:43:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/cpu/idle.c:96
In-Reply-To: <20130430155203.GA512@x4>
Message-ID: <alpine.LFD.2.02.1305021242180.3972@ionos>
References: <20130430155203.GA512@x4>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Markus Trippelsdorf wrote:

> Just booted todays git tree and got the following warning:
> 
> ------------[ cut here ]------------
> WARNING: at kernel/cpu/idle.c:96 cpu_startup_entry+0x14d/0x160()
> Hardware name: System Product Name
> Pid: 0, comm: swapper/2 Not tainted 3.9.0-03462-gab86e97-dirty #424
> Call Trace:
> smpboot: Booting Node   0, Processors  #1 #2
>  [<ffffffff8105b7c0>] ? warn_slowpath_common+0x60/0xa0
>  [<ffffffff8108c26d>] ? cpu_startup_entry+0x14d/0x160
> ---[ end trace 40a24a5550891913 ]---

Fix below.

Thanks,

	tglx

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 607af0d..e4cd638 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -312,6 +312,8 @@ void arch_cpu_idle(void)
 {
 	if (cpuidle_idle_call())
 		x86_idle();
+	else
+		local_irq_enable();
 }
 
 /*
