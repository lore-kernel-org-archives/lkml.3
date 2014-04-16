Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161161AbaDPNll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:41:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36529 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161094AbaDPNlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:41:39 -0400
Date: Wed, 16 Apr 2014 14:27:16 +0100
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
Subject: Re: [PATCH v5 2/4] arm64: split syscall_trace() into separate
 functions for enter/exit
Message-ID: <20140416132716.GA1001@arm.com>
References: <1394705491-12343-1-git-send-email-takahiro.akashi@linaro.org>
 <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org>
 <1394861948-28712-3-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394861948-28712-3-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akashi,

On Sat, Mar 15, 2014 at 05:39:06AM +0000, AKASHI Takahiro wrote:
> As done in arm, this change makes it easy to confirm we invoke syscall
> related hooks, including syscall tracepoint, audit and seccomp which would
> be implemented later, in correct order. That is, undoing operations in the
> opposite order on exit that they were done on entry.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

[...]

> +static void tracehook_report_syscall(struct pt_regs *regs,
> +				     enum ptrace_syscall_dir dir)
>  {
> +	int scrach;

s/scrach/scratch/

Although, I'd rather have a variable with a more meaningful name. How about
regno?

With that,

  Acked-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will
