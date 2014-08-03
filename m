Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaHCVVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 17:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbaHCVVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 17:21:12 -0400
Date: Sun, 3 Aug 2014 23:18:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 0/5] (Was: procfs: silence lockdep warning about read vs.
	exec seq_file)
Message-ID: <20140803211843.GA13330@redhat.com>
References: <1407010227-2269-1-git-send-email-kirill@shutemov.name> <20140803164452.GA14626@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140803164452.GA14626@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Oleg Nesterov wrote:
>
> The question is, why m_start() calls mm_access(). This is not even
> strictly correct if the task execs between m_stop() + m_start().
>
> Can't we do something like below? The patch is obviously horrible and
> incomplete, just to explain what I meant. Basically this is what
> proc_mem_operations does.

Absolutely untested, only for review.

What do you all think?

Sure, with this change you can't open (say) /proc/pid/maps, and read the
new mappings after exec. But hopefully this is fine? And again, this
matches /proc/pid/mem.

lock_trace() users need another fix.

Oleg.

