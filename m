Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab3BBAUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 19:20:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab3BBAUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 19:20:04 -0500
Date: Fri, 1 Feb 2013 16:20:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/9] mm: add SECTION_IN_PAGE_FLAGS
Message-Id: <20130201162002.49eadeb7.akpm@linux-foundation.org>
In-Reply-To: <1358463181-17956-2-git-send-email-cody@linux.vnet.ibm.com>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
	<1358463181-17956-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013 14:52:53 -0800
Cody P Schafer <cody@linux.vnet.ibm.com> wrote:

> Instead of directly utilizing a combination of config options to determine this,
> add a macro to specifically address it.
> 
> ...
>
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -625,6 +625,10 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
>  #define NODE_NOT_IN_PAGE_FLAGS
>  #endif
>  
> +#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +#define SECTION_IN_PAGE_FLAGS
> +#endif

We could do this in Kconfig itself, in the definition of a new
CONFIG_SECTION_IN_PAGE_FLAGS.

I'm not sure that I like that sort of thing a lot though - it's rather a
pain to have to switch from .[ch] over to Kconfig to find the
definitions of things.  I should get off my tail and teach my ctags
scripts to handle this.

