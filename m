Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaHDJYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:24:38 -0400
Received: from mta-out1.inet.fi ([62.71.2.228]:55722 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaHDJYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:24:36 -0400
Date: Mon, 4 Aug 2014 12:20:43 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 0/5] (Was: procfs: silence lockdep warning about read vs.
 exec seq_file)
Message-ID: <20140804092043.GA13940@node.dhcp.inet.fi>
References: <1407010227-2269-1-git-send-email-kirill@shutemov.name>
 <20140803164452.GA14626@redhat.com>
 <20140803211843.GA13330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140803211843.GA13330@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
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

Look good. And works for me.

> Sure, with this change you can't open (say) /proc/pid/maps, and read the
> new mappings after exec. But hopefully this is fine? And again, this
> matches /proc/pid/mem.
> 
> lock_trace() users need another fix.

task_nommu.c need to be covered too, I believe.

-- 
 Kirill A. Shutemov
