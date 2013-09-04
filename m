Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762566Ab3IDONT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:13:19 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63709 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3IDONR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:13:17 -0400
MIME-Version: 1.0
Date: Wed, 4 Sep 2013 10:13:16 -0400
X-Google-Sender-Auth: hDbhamgYSJ7ZGcCK6fDbgmhTgpo
Message-ID: <CA+5PVA6SQ9JGBD3F=u5ysch-agp91oTK8ZbKsdQkz57yZ8OUHQ@mail.gmail.com>
Subject: 3.12 merge window exynos cpufreq driver fails to build
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Kukjin Kim <kgene.kim@samsung.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using Linus' tree as of this morning (v3.11-2654-g458c3f6), the
exynos-cpufreq driver doesn't build because it includes a file that
doesn't exist.

+ make -s ARCH=arm V=1 -j4 bzImage KALLSYMS_EXTRA_PASS=1
arch/arm/kernel/return_address.c:63:2: warning: #warning "TODO:
return_address should use unwind tables" [-Wcpp]
 #warning "TODO: return_address should use unwind tables"
  ^
arch/arm/mm/dma-mapping.c:253:2: warning: #warning ARM Coherent DMA
allocator does not (yet) support huge TLB [-Wcpp]
 #warning ARM Coherent DMA allocator does not (yet) support huge TLB
  ^
drivers/cpufreq/exynos-cpufreq.c:21:22: fatal error: plat/cpu.h: No
such file or directory
 #include <plat/cpu.h>
                      ^
compilation terminated.
make[2]: *** [drivers/cpufreq/exynos-cpufreq.o] Error 1

I'm guessing that <plat/cpu.h> file is supposed to come from
arch/arm/plat-samsung/include/plat/, but I don't see anything that
specifies a -I there.

Thoughts?

josh
