Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbbAVNLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:11:22 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:43896 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbAVNLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:11:19 -0500
Message-ID: <54C0F6D9.70003@linaro.org>
Date: Thu, 22 Jan 2015 13:10:49 +0000
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org
CC: kvm@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to
 be preempted
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com> <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On 22/01/15 02:17, Luis R. Rodriguez wrote:
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> index b4bca2d..23c526b 100644
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -32,6 +32,8 @@
>  #include <linux/slab.h>
>  #include <linux/irqnr.h>
>  #include <linux/pci.h>
> +#include <linux/sched.h>
> +#include <linux/kprobes.h>
>  
>  #ifdef CONFIG_X86
>  #include <asm/desc.h>
> @@ -1243,6 +1245,17 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>  	set_irq_regs(old_regs);
>  }
>  
> +notrace void xen_end_upcall(struct pt_regs *regs)
> +{
> +	if (!xen_is_preemptible_hypercall(regs) ||

I don't see any definition of xen_is_preemptible_hypercall for ARM32/ARM64.

As this function is called from the generic code, you have at least to
stub this function for those architectures.

Regards,

-- 
Julien Grall
