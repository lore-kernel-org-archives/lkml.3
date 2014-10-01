Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbaJALjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:39:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36691 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaJALjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:39:42 -0400
Message-ID: <542BE7F5.2000808@oracle.com>
Date: Wed, 01 Oct 2014 07:39:33 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: generalize VM_BUG_ON() macros
References: <1412163121-4295-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1412163121-4295-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 07:31 AM, Kirill A. Shutemov wrote:
> +#define _VM_DUMP(arg, cond) do {					\
> +	if (__builtin_types_compatible_p(typeof(*arg), struct page))	\
> +		dump_page((struct page *) arg,				\
> +				"VM_BUG_ON(" __stringify(cond)")");	\
> +	else if (__builtin_types_compatible_p(typeof(*arg),		\
> +				struct vm_area_struct))			\
> +		dump_vma((struct vm_area_struct *) arg);		\
> +	else if (__builtin_types_compatible_p(typeof(*arg),		\
> +				struct mm_struct))			\
> +		dump_mm((struct mm_struct *) arg);			\
> +	else								\
> +		BUILD_BUG();						\
> +} while(0)

__same_type() instead of __builtin_types_compatible_p() would look nicer,
but I don't think that all compilers support that:

	include/linux/compiler-intel.h:/* Intel ECC compiler doesn't support __builtin_types_compatible_p() */

So it would effectively disable VM_BUG_ONs on Intel's compiler.


Thanks,
Sasha
