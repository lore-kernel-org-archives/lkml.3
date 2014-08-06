Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaHFKTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:19:07 -0400
Received: from mta-out1.inet.fi ([62.71.2.231]:51711 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbaHFKTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:19:05 -0400
Date: Wed, 6 Aug 2014 13:18:28 +0300
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
Subject: Re: [PATCH v2 7/7] fs/proc/task_mmu.c: shift "priv->task = NULL"
 from m_start() to m_stop()
Message-ID: <20140806101828.GC30703@node.dhcp.inet.fi>
References: <20140805194627.GA30693@redhat.com>
 <20140805194707.GA30746@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194707.GA30746@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:47:07PM +0200, Oleg Nesterov wrote:
> 1. There is no reason to reset ->tail_vma in m_start(), if we return
>    IS_ERR_OR_NULL() it won't be used.
> 
> 2. m_start() also clears priv->task to ensure that m_stop() won't use
>    the stale pointer if we fail before get_task_struct(). But this is
>    ugly and confusing, move this initialization in m_stop().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
