Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3KGLAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:00:42 -0500
Received: from multi.imgtec.com ([194.200.65.239]:31264 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab3KGLAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:00:39 -0500
Message-ID: <527B72AF.50002@imgtec.com>
Date: Thu, 7 Nov 2013 10:59:59 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Eric Paris <eparis@redhat.com>,
        <libseccomp-discuss@lists.sourceforge.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Will Drewry <wad@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] seccomp: not compatible with ARM OABI
References: <20131106233117.GA24545@www.outflux.net>
In-Reply-To: <20131106233117.GA24545@www.outflux.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_07_11_00_01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/11/13 23:31, Kees Cook wrote:
> diff --git a/arch/Kconfig b/arch/Kconfig
> index af2cc6eabcc7..6eaca7d92399 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -331,12 +331,15 @@ config HAVE_ARCH_SECCOMP_FILTER
>  
>  config SECCOMP_FILTER
>  	def_bool y
> -	depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET
> +	depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET && !OABI_COMPAT

Isn't this the whole point of HAVE_ARCH_SECCOMP_FILTER?

Just change the select in arch/arm/Kconfig to this:

	select HAVE_ARCH_SECCOMP_FILTER if !OABI_COMPAT

Cheers
James

