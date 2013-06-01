Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab3FAOuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 10:50:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42137 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab3FAOuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 10:50:25 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1370080739.29224.36.camel@localhost.localdomain>
References: <1370080739.29224.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86, msr/cpuid: Cocci spatch "ptr_ret.spatch"
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 01 Jun 2013 07:49:49 -0700
To: Thomas Meyer <thomas@m3y3r.de>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Message-ID: <0ef28eaf-e73e-4ed8-89d9-2b8db4d2715b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not an acceptable patch... no description of any kind and a subject line which would only make sense if the cocci scripts are checked into the kernel tree.

Thomas Meyer <thomas@m3y3r.de> wrote:

>
>Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
>---
>
>diff -u -p a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
>--- a/arch/x86/kernel/cpuid.c
>+++ b/arch/x86/kernel/cpuid.c
>@@ -143,7 +143,7 @@ static __cpuinit int cpuid_device_create
> 
> 	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu), NULL,
> 			    "cpu%d", cpu);
>-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
>+	return PTR_RET(dev);
> }
> 
> static void cpuid_device_destroy(int cpu)
>diff -u -p a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
>--- a/arch/x86/kernel/msr.c
>+++ b/arch/x86/kernel/msr.c
>@@ -206,7 +206,7 @@ static int __cpuinit msr_device_create(i
> 
> 	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu), NULL,
> 			    "msr%d", cpu);
>-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
>+	return PTR_RET(dev);
> }
> 
> static void msr_device_destroy(int cpu)

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
