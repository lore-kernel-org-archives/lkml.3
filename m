Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3ARNLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:11:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44091 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab3ARNLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:11:02 -0500
Date: Fri, 18 Jan 2013 14:10:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Message-ID: <20130118131056.GA14550@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
	olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
	tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@kernel.org>
References: <1358469577-8794-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1358469577-8794-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 04:39:37PM -0800, K. Y. Srinivasan wrote:
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  arch/x86/include/asm/irq_vectors.h |    2 +
>  arch/x86/include/asm/mshyperv.h    |    4 +++
>  arch/x86/kernel/cpu/mshyperv.c     |   39 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/entry_32.S         |    7 ++++++
>  arch/x86/kernel/entry_64.S         |    5 ++++
>  5 files changed, 57 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index 1508e51..c2ff239 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -112,6 +112,8 @@
>  /* Xen vector callback to receive events in a HVM domain */
>  #define XEN_HVM_EVTCHN_CALLBACK		0xf3
>  
> +/* Hyper-V vector callback to receive vmbus interrupts*/
> +#define HYPER_V_CALLBACK_VECTOR		0xf2

Btw, could those hypervisor vectors be merged into one VIRT_INTR_VECTOR
and be shared between the hypervisors? I mean, you can't have a xen and
hyperv hypervisor running next to each other and fihgting over that
vector, right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
