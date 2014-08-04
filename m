Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaHDG7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:59:55 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:36333 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaHDG7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:59:53 -0400
Date: Mon, 4 Aug 2014 10:59:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 0/5] (Was: procfs: silence lockdep warning about read vs.
 exec seq_file)
Message-ID: <20140804065950.GB2239@moon>
References: <1407010227-2269-1-git-send-email-kirill@shutemov.name>
 <20140803164452.GA14626@redhat.com>
 <20140803211843.GA13330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140803211843.GA13330@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2014 at 11:18:43PM +0200, Oleg Nesterov wrote:
> On 08/03, Oleg Nesterov wrote:
> >
> > The question is, why m_start() calls mm_access(). This is not even
> > strictly correct if the task execs between m_stop() + m_start().
> >
> > Can't we do something like below? The patch is obviously horrible and
> > incomplete, just to explain what I meant. Basically this is what
> > proc_mem_operations does.
> 
> Absolutely untested, only for review.
> 
> What do you all think?
> 
> Sure, with this change you can't open (say) /proc/pid/maps, and read the
> new mappings after exec. But hopefully this is fine? And again, this
> matches /proc/pid/mem.
> 
> lock_trace() users need another fix.

If only I didn't miss something obvious this is quite the good cleanup,
thanks Oleg!
