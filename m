Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab3LEN6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:58:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab3LEN6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:58:49 -0500
Date: Thu, 5 Dec 2013 08:58:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        linux-mips@linux-mips.org, stable@vger.kernel.org
Subject: Re: [PATCH] crash_dump: fix compilation error (on MIPS at least)
Message-ID: <20131205135835.GA1600@redhat.com>
References: <1386172702-31266-1-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386172702-31266-1-git-send-email-qais.yousef@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 03:58:22PM +0000, Qais Yousef wrote:
>   In file included from kernel/crash_dump.c:2:0:
>   include/linux/crash_dump.h:22:27: error: unknown type name ‘pgprot_t’
> 
> when CONFIG_CRASH_DUMP=y
> 
> The error was traced back to this commit:
> 
>   9cb218131de1 vmcore: introduce remap_oldmem_pfn_range()
> 
> include <asm/pgtable.h> to get the missing definition
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: <linux-mips@linux-mips.org>
> Cc: <stable@vger.kernel.org> # 3.12
> Reviewed-by: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> ---

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> I haven't tried any other architecture except mips.
> If OK this should be considered for stable 3.12 (CCed).
> 
>  include/linux/crash_dump.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
> index fe68a5a..7032518 100644
> --- a/include/linux/crash_dump.h
> +++ b/include/linux/crash_dump.h
> @@ -6,6 +6,8 @@
>  #include <linux/proc_fs.h>
>  #include <linux/elf.h>
>  
> +#include <asm/pgtable.h> /* for pgprot_t */
> +
>  #define ELFCORE_ADDR_MAX	(-1ULL)
>  #define ELFCORE_ADDR_ERR	(-2ULL)
>  
> -- 
> 1.7.1
> 
