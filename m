Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaHFKRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:17:51 -0400
Received: from mta-out1.inet.fi ([62.71.2.230]:33748 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbaHFKRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:17:49 -0400
Date: Wed, 6 Aug 2014 13:17:18 +0300
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
Subject: Re: [PATCH v2 6/7] fs/proc/task_mmu.c: cleanup the "tail_vma" horror
 in m_next()
Message-ID: <20140806101718.GB30703@node.dhcp.inet.fi>
References: <20140805194627.GA30693@redhat.com>
 <20140805194703.GA30739@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194703.GA30739@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:47:03PM +0200, Oleg Nesterov wrote:
> 1. Kill the first "vma != NULL" check. Firstly this is not possible,
>    m_next() won't be called if ->start() or the previous ->next()
>    returns NULL.
> 
>    And if it was possible the 2nd "vma != tail_vma" check is buggy,
>    we should not wrongly return ->tail_vma.
> 
> 2. Make this function readable. The logic is very simple, we should
>    return check "vma != tail" once and return "vm_next || tail_vma".
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
