Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaJANSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:18:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:65379 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaJANSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:18:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,632,1406617200"; 
   d="scan'208";a="608139501"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <542BE7F5.2000808@oracle.com>
References: <1412163121-4295-1-git-send-email-kirill.shutemov@linux.intel.com>
 <542BE7F5.2000808@oracle.com>
Subject: Re: [PATCH 1/3] mm: generalize VM_BUG_ON() macros
Content-Transfer-Encoding: 7bit
Message-Id: <20141001131812.1893BE00A3@blue.fi.intel.com>
Date: Wed,  1 Oct 2014 16:18:12 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin wrote:
> On 10/01/2014 07:31 AM, Kirill A. Shutemov wrote:
> > +#define _VM_DUMP(arg, cond) do {					\
> > +	if (__builtin_types_compatible_p(typeof(*arg), struct page))	\
> > +		dump_page((struct page *) arg,				\
> > +				"VM_BUG_ON(" __stringify(cond)")");	\
> > +	else if (__builtin_types_compatible_p(typeof(*arg),		\
> > +				struct vm_area_struct))			\
> > +		dump_vma((struct vm_area_struct *) arg);		\
> > +	else if (__builtin_types_compatible_p(typeof(*arg),		\
> > +				struct mm_struct))			\
> > +		dump_mm((struct mm_struct *) arg);			\
> > +	else								\
> > +		BUILD_BUG();						\
> > +} while(0)
> 
> __same_type() instead of __builtin_types_compatible_p() would look nicer,
> but I don't think that all compilers support that:
> 
> 	include/linux/compiler-intel.h:/* Intel ECC compiler doesn't support __builtin_types_compatible_p() */
> 
> So it would effectively disable VM_BUG_ONs on Intel's compiler

We can make _VM_DUMP nop, but I don't think ICC can build kernel anyway:
we already use __builtin_types_compatible_p() in i915 driver and other
places. Nobody cares.

Any other comments?

-- 
 Kirill A. Shutemov
