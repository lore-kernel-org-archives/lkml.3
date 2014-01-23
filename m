Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaAWOyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:54:46 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43564 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753840AbaAWOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:54:45 -0500
Date: Thu, 23 Jan 2014 14:53:51 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>, Will Deacon <Will.Deacon@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v2 5/6] arm64: audit: Add makefile rule to create
 unistd_32.h for compat syscalls
Message-ID: <20140123145351.GF27520@arm.com>
References: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org>
 <1389946399-4525-6-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389946399-4525-6-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 08:13:18AM +0000, AKASHI Takahiro wrote:
> generic compat sycall audit (lib/compat_audit.c) requires unistd_32.h
> for __NR_xyx compat syscall numbers. This is a different file from unistd32.h
> on arm64 and so it must be generated from unistd32.h.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/Makefile                 |    4 ++++
>  arch/arm64/kernel/syscalls/Makefile |   20 ++++++++++++++++++++
>  2 files changed, 24 insertions(+)
>  create mode 100644 arch/arm64/kernel/syscalls/Makefile
> 
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index 2fceb71..6d24f92 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -72,6 +72,10 @@ PHONY += vdso_install
>  vdso_install:
>  	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso $@
>  
> +# Compat syscall header generation
> +archheaders:
> +	$(Q)$(MAKE) $(build)=arch/arm64/kernel/syscalls $@

See my other post to the lib/compat_audit.c file. I think that's too
complex for what you need.

-- 
Catalin
