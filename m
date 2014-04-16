Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161314AbaDPNcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:32:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36184 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161040AbaDPNcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:32:45 -0400
Date: Wed, 16 Apr 2014 14:29:31 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>
Subject: Re: [PATCH v5 4/4] arm64: is_compat_task is defined both in
 asm/compat.h and linux/compat.h
Message-ID: <20140416132931.GB1001@arm.com>
References: <1394705491-12343-1-git-send-email-takahiro.akashi@linaro.org>
 <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org>
 <1394861948-28712-5-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394861948-28712-5-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 05:39:08AM +0000, AKASHI Takahiro wrote:
> Some kernel files may include both linux/compat.h and asm/compat.h directly
> or indirectly. Since both header files contain is_compat_task() under
> !CONFIG_COMPAT, compiling them with !CONFIG_COMPAT will eventually fail.
> Such files include kernel/auditsc.c, kernel/seccomp.c and init/do_mountfs.c
> (do_mountfs.c may read asm/compat.h via asm/ftrace.h once ftrace is
> implemented).
> 
> So this patch proactively
> 1) removes is_compat_task() under !CONFIG_COMPAT from asm/compat.h
> 2) replaces asm/compat.h to linux/compat.h in kernel/*.c,
>    but asm/compat.h is still necessary in ptrace.c and process.c because
>    they use is_compat_thread().
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
