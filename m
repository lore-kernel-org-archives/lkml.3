Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaG3Ni2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:38:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbaG3Ni0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:38:26 -0400
Message-ID: <53D8F550.2070800@suse.cz>
Date: Wed, 30 Jul 2014 15:38:24 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Kbuild: Add a option to enable dwarf4
References: <1406675493-2539-1-git-send-email-andi@firstfloor.org> <1406675493-2539-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1406675493-2539-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-30 01:11, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> I found that a lot of unresolvable variables when using gdb on the kernel
> become resolvable when dwarf4 is enabled. So add a Kconfig flag to enable it.
> 
> It definitely increases the debug information size, but on the other
> hand this isn't so bad when debug fusion is used.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Makefile          | 3 +++
>  lib/Kconfig.debug | 9 +++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 6a717cd..6cdf3f0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -696,6 +696,9 @@ KBUILD_CFLAGS	+= -g
>  endif
>  KBUILD_AFLAGS	+= -Wa,-gdwarf-2
>  endif
> +ifdef CONFIG_DEBUG_INFO_DWARF4
> +KBUILD_CFLAGS	+= -gdwarf-4
> +endif

Make it $(call cc-option,-gdwarf-4), so as not to break allmodconfig
with older GCCs. Otherwise the patch is OK.

Michal
