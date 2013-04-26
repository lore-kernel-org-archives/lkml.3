Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3DZVrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 17:47:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43667 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab3DZVry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 17:47:54 -0400
Message-ID: <517AF5D6.1040800@zytor.com>
Date: Fri, 26 Apr 2013 14:47:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 2/6] x86: kaslr: move CPU flags out of cpucheck
References: <1367003005-5560-1-git-send-email-keescook@chromium.org> <1367003005-5560-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1367003005-5560-3-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 12:03 PM, Kees Cook wrote:
> +
> +static inline void cpuid(u32 id, u32 *a, u32 *b, u32 *c, u32 *d)
> +{
> +	/* Handle x86_32 PIC using ebx. */
> +	asm volatile("movl %%ebx, %%edi	\n\t"
> +		     "cpuid		\n\t"
> +		     "xchgl %%edi, %%ebx\n\t"
> +		    : "=a" (*a),
> +		      "=D" (*b),
> +		      "=c" (*c),
> +		      "=d" (*d)
> +		    : "a" (id)
> +	);
> +}

Please don't constrain registers unnecessarily.

You can use "=r" there and let gcc assign whatever free register it pleases.

You can also limit that to only:

#if defined(__i386__) && defined(__PIC__)

	-hpa

