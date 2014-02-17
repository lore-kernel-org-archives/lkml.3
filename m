Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaBQJ21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:28:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55414 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaBQJ2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:28:24 -0500
Message-ID: <5301D615.8090907@zytor.com>
Date: Mon, 17 Feb 2014 01:27:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [tip:x86/vdso] x86, vdso: Instead of dummy functions, include
 < linux/spinlock_up.h>
References: <1392587568-7325-10-git-send-email-stefani@seibold.net>	 <tip-bd9ee7fd99f127ee1306289415141d45792c97f3@git.kernel.org>	 <53018ABA.20005@zytor.com> <1392622944.1036.13.camel@wall-e.seibold.net>
In-Reply-To: <1392622944.1036.13.camel@wall-e.seibold.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 11:42 PM, Stefani Seibold wrote:
> I think for the first time it will be okay to kick out the
> _ASM_X86_SPINLOCK_H hack and accept the C=1 warnings.
>
> At next step it is necessary to make the whole BUILD_VDSO32 path in
> vclock_gettime.c independent from the kernel headers, only uapi/ should
> be included.
>
> The use of cycle_t must be replaced with u64.
>
> We need a own copy of __native_read_tsc(), __iter_div_u64_rem, smp_rmb()
> and cpu_relax().

All of which are quite trivial.

> For the non BUILD_VDSO32 path we must only move the #includes inside
> this #ifndef BUILD_VDSO32

Sorry, didn't quite follow that.

	-hpa


