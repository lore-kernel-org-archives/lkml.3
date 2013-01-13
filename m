Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3AMM47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 07:56:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52778 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab3AMM45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 07:56:57 -0500
Date: Sun, 13 Jan 2013 13:56:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: Re: [PATCH v7u1 21/31] x86, kexec: only set ident mapping for ram.
Message-ID: <20130113125653.GA17200@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org,
	Alexander Duyck <alexander.h.duyck@intel.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-22-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1357260531-11115-22-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:41PM -0800, Yinghai Lu wrote:
> We should not set mapping for all under max_pfn.

"We should not establish mappings for all memory under max_pfn."

> That causes same problem that is fixed by

"Otherwise, it causes the same ..."

> 
> 	x86, mm: Only direct map addresses that are marked as E820_RAM

You could add this patch's commit id since it is in tip:x86/mm2 and it
shouldn't change: 66520ebc2df3.

Ditto for patch 09/31, "x86, 64bit: #PF handler set page to cover 2M only".

> 
> This patch expose pfn_mapped array, and only set ident mapping for ranges

	     exposes the...		       sets

> in that array.
> 
> This patch rely on new ident_mapping_init that could handle existing

	     relies on the new

> pgd/pud between different calling.

			    calls.

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Alexander Duyck <alexander.h.duyck@intel.com>

[ … ]

> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index ab26a158b5a8..d704b369fd70 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -300,8 +300,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
>         return nr_range;
>  }
>  
> -static struct range pfn_mapped[E820_X_MAX];
> -static int nr_pfn_mapped;

This could use a comment saying that this is an array of all mapped
memory ranges or something like that.

> +struct range pfn_mapped[E820_X_MAX];
> +int nr_pfn_mapped;
>  
>  static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
>  {

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
