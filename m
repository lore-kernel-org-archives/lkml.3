Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaLIUg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:36:59 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:39537 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaLIUg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:36:57 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412092103270.16275@nanos>
References: <1418140999-29092-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1412092103270.16275@nanos>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 9 Dec 2014 15:36:26 -0500
Message-ID: <CAJhHMCAORzK4Yc-DrEmFxwwyWwxWTCQzv1WKd1M6+YiEn9HKiA@mail.gmail.com>
Subject: Re: [RFC PATCH] smpboot: Check for successfull allocation of cpumask vars
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Igor Mammedov <imammedo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 3:10 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 9 Dec 2014, Pranith Kumar wrote:
>> zalloc_cpumask_var() can return 0 on allocation failure when
>> CONFIG_CPUMASK_OFFSTACK is set. Check for the return value and WARN() on failure
>> of an allocation in such cases.
>
> And that warning helps in which way?
>
> It just prints a completely useless backtrace and breaks out of the
> loop, but it does not prevent that later on code will trip over the
> non allocated per cpu data.
>

I agree. May be just a pr_warn() saying that an allocation failed perhaps?

To prevent further accesses, we can clear the cpu bit from the cpu
masks(online/possible/present) for the failed cpu and continue trying
to allocate for other cpus. We don't break out of the loop. Removing
the cpu from the cpu masks will disable accesses of the non allocated
per cpu data.

What do you suggest we do in such cases?
-- 
Pranith
