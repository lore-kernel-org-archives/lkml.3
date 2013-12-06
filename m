Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162576Ab3LFN0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:26:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46993 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241Ab3LFN0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:26:53 -0500
Date: Fri, 6 Dec 2013 14:26:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: [PATCH 1/3] x86, mpx: add documentation on Intel MPX
Message-ID: <20131206132648.GB6694@pd.tnic>
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 02:52:54AM +0800, Qiaowei Ren wrote:
> This patch adds the Documentation/intel_mpx.txt file with some
> information about Intel MPX.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  Documentation/intel_mpx.txt |   77 +++++++++++++++++++++++++++++++++++++++++++

Documentation/x86/ is probably a more fitting place for this.

>  1 files changed, 77 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/intel_mpx.txt
> 
> diff --git a/Documentation/intel_mpx.txt b/Documentation/intel_mpx.txt
> new file mode 100644
> index 0000000..3d947d0
> --- /dev/null
> +++ b/Documentation/intel_mpx.txt
> @@ -0,0 +1,77 @@
> +Intel(R) MPX Overview:
> +=====================
> +
> +Intel(R) Memory Protection Extensions (Intel(R) MPX) is a new
> +capability introduced into Intel Architecture. Intel MPX can
> +increase the robustness of software when it is used in conjunction
> +with compiler changes to check memory references, for those
> +references whose compile-time normal intentions are usurped

That's a strange formulation, what does it actually mean? The intentions
of references??

> +at runtime due to buffer overflow or underflow.
> +
> +Two of the most important goals of Intel MPX are to provide
> +this capability at very low performance overhead for newly
> +compiled code, and to provide compatibility mechanisms with
> +legacy software components. A direct benefit Intel MPX provides
> +is hardening software against malicious attacks designed to
> +cause or exploit buffer overruns.
> +
> +For details about the Intel MPX instructions, see "Intel(R)
> +Architecture Instruction Set Extensions Programming Reference".
> +
> +Intel(R) MPX Programming Model
> +------------------------------
> +
> +Intel MPX introduces new registers and new instructions that
> +operate on these registers. Some of the registers added are
> +bounds registers which store a pointer's lower bound and upper
> +bound limits. Whenever the pointer is used, the requested
> +reference is checked against the pointer's associated bounds,
> +thereby preventing out-of-bound memory access (such as buffer
> +overflows and overruns). Out-of-bounds memory references
> +initiate a #BR exception which can then be handled in an
> +appropriate manner.
> +
> +Loading and Storing Bounds using Translation
> +--------------------------------------------
> +
> +Intel MPX defines two instructions for load/store of the linear
> +address of a pointer to a buffer, along with the bounds of the
> +buffer into a paging structure of extended bounds. Specifically
> +when storing extended bounds, the processor will perform address
> +translation of the address where the pointer is stored to an
> +address in the Bound Table (BT) to determine the store location
> +of extended bounds. Loading of an extended bounds performs the

s/an//

> +reverse sequence.
> +

...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
