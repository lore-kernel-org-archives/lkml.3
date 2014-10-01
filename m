Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaJAUFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:05:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJAUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:05:24 -0400
Date: Wed, 1 Oct 2014 13:05:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Hansen <dave.hansen@intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: generalize VM_BUG_ON() macros
Message-Id: <20141001130523.d7cf46e735089d681194e8e6@linux-foundation.org>
In-Reply-To: <1412163121-4295-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1412163121-4295-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Oct 2014 14:31:59 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> This patch makes VM_BUG_ON() to accept one to three arguments after the
> condition. Any of these arguments can be page, vma or mm. VM_BUG_ON()
> will dump info about the argument using appropriate dump_* function.
> 
> It's intended to replace separate VM_BUG_ON_PAGE(), VM_BUG_ON_VMA(),
> VM_BUG_ON_MM() and allows additional use-cases like:
> 
>   VM_BUG_ON(cond, vma, page);
>   VM_BUG_ON(cond, vma, src_page, dst_page);
>   VM_BUG_ON(cond, mm, src_vma, dst_vma);
>   ...

I can't say I'm a fan of this.  We don't do this sort of thing anywhere
else in the kernel and passing different types to the same thing in
different places is unusual and exceptional.  We gain very little from
this so why bother?

Adding new printk(%p) thingies for vmas and pages would be more
consistent but still of dubious value.
