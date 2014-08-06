Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaHFKNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:13:21 -0400
Received: from mta-out1.inet.fi ([62.71.2.230]:38923 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbaHFKNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:13:20 -0400
Date: Wed, 6 Aug 2014 13:12:45 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] fs/proc/task_mmu.c: simplify the vma_stop() logic
Message-ID: <20140806101245.GA30703@node.dhcp.inet.fi>
References: <20140805194627.GA30693@redhat.com>
 <20140805194659.GA30736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194659.GA30736@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:46:59PM +0200, Oleg Nesterov wrote:
> m_start() drops ->mmap_sem and does mmput() if it retuns vsyscall
> vma. This is because in this case m_stop()->vma_stop() obviously
> can't use gate_vma->vm_mm.
> 
> Now that we have proc_maps_private->mm we can simplify this logic:
> 
>   - Change m_start() to return with ->mmap_sem held unless it returns
>     IS_ERR_OR_NULL().
> 
>   - Change vma_stop() to use priv->mm and avoid the ugly vma checks,
>     this makes "vm_area_struct *vma" unnecessary.
> 
>   - This also allows m_start() to use vm_stop().
> 
>   - Cleanup m_next() to follow the new locking rule.
> 
>     Note: m_stop() looks very ugly, and this temporary uglifies it
>     even more. Fixed by the next change.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
