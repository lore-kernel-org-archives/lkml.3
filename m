Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab3GCAud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:50:33 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:34284 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab3GCAua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:50:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130701090356.GA14912@gmail.com>
References: <20130701090356.GA14912@gmail.com>
Date: Tue, 2 Jul 2013 17:50:29 -0700
X-Google-Sender-Auth: va9odB2OW3HNWwE6bXpLbLcQlIw
Message-ID: <CA+55aFwJwYRbPBBN1ma8TBHuomo_AJjajxT6YDmdGXJdE4EgrQ@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 2:03 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus
>
> Kernel improvements:
>
>  * AMD IOMMU uncore PMU support by Suravee Suthikulpanit001a

This one prints a really annoying error message if you're not on an
AMD platform:

+       if (!amd_iommu_pc_supported()) {
+               pr_err("perf: amd_iommu PMU not installed. No support!\n");
+               return -ENODEV;
+       }

and you know what? That's not acceptable. It damn well is *not* an
error to not have an AMD IOMMU.

It should - at most - be a pr_info(). Maybe nothing at all. "pr_err()"
is just totally out of line.

             Linus
