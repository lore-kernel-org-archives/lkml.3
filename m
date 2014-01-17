Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaAQQrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:47:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36701 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248AbaAQQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:47:07 -0500
Date: Fri, 17 Jan 2014 16:46:11 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v2 4/6] arm64: audit: Add 32-bit (compat) syscall support
Message-ID: <20140117164610.GQ16003@mudshark.cambridge.arm.com>
References: <1383733546-2846-1-git-send-email-takahiro.akashi@linaro.org>
 <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org>
 <1389946399-4525-5-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389946399-4525-5-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akashi,

On Fri, Jan 17, 2014 at 08:13:17AM +0000, AKASHI Takahiro wrote:
> Generic audit code also support compat system calls now.
> This patch adds a small piece of architecture dependent code.

[...]

>  static inline int syscall_get_nr(struct task_struct *task,
> @@ -109,6 +110,15 @@ static inline void syscall_set_arguments(struct task_struct *task,
>  static inline int syscall_get_arch(struct task_struct *task,
>  				   struct pt_regs *regs)
>  {
> +#ifdef CONFIG_COMPAT
> +	if (is_compat_thread(task_thread_info(task)))

You can call is_compat_thread even when !CONFIG_COMPAT, so you don't need
that #ifdef.

> +#ifdef __AARCH64EB__
> +		return AUDIT_ARCH_ARMEB; /* only BE on BE */

Well, actually, we only support userspace to be the same endianness as the
kernel, so you that comment is slightly misleading. You could probably avoid
these repeated ifdefs by defining things like ARM64_AUDIT_ARCH and
ARM64_COMPAT_AUDIT_ARCH once depending on endianness.

Will
