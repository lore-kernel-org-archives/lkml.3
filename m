Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaJ0LbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:31:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:6987 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaJ0LbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:31:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,795,1406617200"; 
   d="scan'208";a="612019566"
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8 only] x86,vdso: Use LSL unconditionally for vgetcpu
References: <d2466423e1d88f24a52e746d4f5c6a7abce982ae.1413844952.git.luto@amacapital.net>
Date: Mon, 27 Oct 2014 04:31:02 -0700
In-Reply-To: <d2466423e1d88f24a52e746d4f5c6a7abce982ae.1413844952.git.luto@amacapital.net>
	(Andy Lutomirski's message of "Mon, 20 Oct 2014 15:44:46 -0700")
Message-ID: <87wq7lpx55.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> LSL is faster than RDTSCP and works everywhere; there's no need to
> switch between them depending on CPU.

Yes it should have been done like this from day 1.

> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index 9793322751e0..d14bb8faad16 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -11,6 +11,9 @@
>   * Check with readelf after changing.
>   */
>  
> +/* Disable static_cpu_has debugging; it doesn't work in the vDSO */
> +#undef CONFIG_X86_DEBUG_STATIC_CPU_HAS
> +
>  #include <uapi/linux/time.h>
>  #include <asm/vgtod.h>
>  #include <asm/hpet.h>
> diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
> index add1d98d2477..fd8470c98ab5 100644
> --- a/arch/x86/vdso/vgetcpu.c
> +++ b/arch/x86/vdso/vgetcpu.c
> @@ -5,10 +5,12 @@
>   * Fast user context implementation of getcpu()
>   */
>  
> +/* Disable static_cpu_has debugging; it doesn't work in the vDSO */
> +#undef CONFIG_X86_DEBUG_STATIC_CPU_HAS


These two hunks are unrelated?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
