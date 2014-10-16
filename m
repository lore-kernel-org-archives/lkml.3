Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaJPFJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:09:49 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47059 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaJPFJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:09:47 -0400
Date: Thu, 16 Oct 2014 07:09:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 02/10] x86, intel-mid: Remove "weak" from function
 declarations
Message-ID: <20141016050942.GA14640@gmail.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20141015170554.4063.62975.stgit@bhelgaas-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015170554.4063.62975.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bjorn Helgaas <bhelgaas@google.com> wrote:

> For the following interfaces:
> 
>   get_penwell_ops()
>   get_cloverview_ops()
>   get_tangier_ops()
> 
> there is only one implementation, so they do not need to be marked "weak".
> 
> Remove the "weak" attribute from their declarations.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: David Cohen <david.a.cohen@linux.intel.com>
> CC: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> CC: x86@kernel.org
> ---
>  arch/x86/platform/intel-mid/intel_mid_weak_decls.h |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> index 46aa25c8ce06..3c1c3866d82b 100644
> --- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> +++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> @@ -10,10 +10,9 @@
>   */
>  
>  
> -/* __attribute__((weak)) makes these declarations overridable */
>  /* For every CPU addition a new get_<cpuname>_ops interface needs
>   * to be added.
>   */
> -extern void *get_penwell_ops(void) __attribute__((weak));
> -extern void *get_cloverview_ops(void) __attribute__((weak));
> -extern void *get_tangier_ops(void) __attribute__((weak));
> +extern void *get_penwell_ops(void);
> +extern void *get_cloverview_ops(void);
> +extern void *get_tangier_ops(void);

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
