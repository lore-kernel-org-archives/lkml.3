Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538Ab3DHQL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:11:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38272 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934761Ab3DHQL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:11:26 -0400
Message-ID: <5162EC1A.4050204@zytor.com>
Date: Mon, 08 Apr 2013 09:11:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
References: <20130403193743.GB29151@sgi.com> <20130408155701.GB19974@gmail.com>
In-Reply-To: <20130408155701.GB19974@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 08:57 AM, Ingo Molnar wrote:
> 
> I think the original commit:
> 
>   f96972f2dc63 kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
> 
> actually regressed your 1024 CPU systems, and should possibly be reverted or fixed 
> in some other fashion - such as by migrating to the primary CPU (on architectures 
> that require that), instead of hotplug offlining every secondary CPU on every 
> architecture!
> 
> Alternatively, disable_nonboot_cpus() could perhaps be improved to down CPUs in 
> parallel: issue the CPU-down requests to every CPU, then wait for them to complete 
> - instead of the loop over every CPU?
> 
> This would be the conceptual counter part to parallel boot up of CPUs - something 
> SGI might be interested in as well?
> 

Migrating to the boot processor and then calling stop_machine() to
defang any other processors should be sufficient, no?

I don't know if there is any reason to deschedule all tasks?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

