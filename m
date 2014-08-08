Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaHHUF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:05:59 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40939 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaHHUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:05:57 -0400
Date: Sat, 9 Aug 2014 00:05:53 +0400
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
Message-ID: <20140808200553.GB20553@moon>
References: <20140808185732.GA760@redhat.com>
 <20140808185747.GA774@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808185747.GA774@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 08:57:47PM +0200, Oleg Nesterov wrote:
...
> +++ b/fs/proc/inode.c
> @@ -73,6 +73,7 @@ static struct inode *proc_alloc_inode(struct super_block *sb)
>  	ei->pde = NULL;
>  	ei->sysctl = NULL;
>  	ei->sysctl_entry = NULL;
> +	ei->pid_entry = NULL;
>  	ei->ns.ns = NULL;
>  	ei->ns.ns_ops = NULL;
>  	inode = &ei->vfs_inode;

Hi Oleg, sorry for not responding to previous emails, will try to review this
things tomorrow (from a glance looks quite good!). Btw, this moment strike my
eyes -- why don't we use kmem_cache_zalloc here but do assign nils again and
again, maybe worth to address as well?
