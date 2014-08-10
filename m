Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaHJHQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 03:16:07 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:55485 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHJHQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 03:16:05 -0400
Date: Sun, 10 Aug 2014 11:16:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] proc: intoduce proc_inode->pid_entry and
 is_tgid_pid_entry()
Message-ID: <20140810071601.GB14546@moon>
References: <20140808185732.GA760@redhat.com>
 <20140808185747.GA774@redhat.com>
 <20140808200553.GB20553@moon>
 <20140809142850.GB16457@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809142850.GB16457@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 04:28:50PM +0200, Oleg Nesterov wrote:
> >
> > Hi Oleg, sorry for not responding to previous emails, will try to review this
> > things tomorrow (from a glance looks quite good!). Btw, this moment strike my
> > eyes -- why don't we use kmem_cache_zalloc here but do assign nils again and
> > again, maybe worth to address as well?
> 
> Probably because this doesn't make sense to nullify proc_inode->vfs_inode,
> it will be reinitialized at least by inode_init_always() anyway.

  Yeah, thanks. I managed to fogeth that we call inode_init_always after inode
get allocated. As to series -- looks like a good start, and I think Eric
is a way more confident in this area than me so i've nothing to add up
to his comments.
