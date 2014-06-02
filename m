Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaFBTYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:24:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaFBTYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:24:54 -0400
Date: Mon, 2 Jun 2014 21:23:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>,
        Hugh Dickins <hughd@google.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: tmpfs support
Message-ID: <20140602192344.GA30792@redhat.com>
References: <20140602141406.GA17863@redhat.com> <20140602183028.GA9372@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602183028.GA9372@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Christoph Hellwig wrote:
>
> On Mon, Jun 02, 2014 at 04:14:06PM +0200, Oleg Nesterov wrote:
> > Ingo, please pull from
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> >
> > Based on tip:perf/uprobes
>
> Eww, adding tmpfs-specific code to uprobes screams layering violation.
>
> Hugh, what is the problem with implementing ->readpage for tmpfs again?

I leave this to you and Hugh.

But I hope you are not arguing with this patch, it is very simple and we
do want to support tmpfs. If tmpfs has ->readpage again we can revert this
patch.



BTW. Is it safe to pass file == NULL to read_mapping_page() and ->readpage()?
Last time I tried to check this looked safe but this is not documented. We
need to call read_mapping_page() from uprobe_register() but it doesn't have
"struct file *" and thus we need to delay arch_uprobe_analyze_insn() until
we find the first mapping, too bad.

And why read_mapping_page() has "void *data" but not "struct file *file"...

Oleg.

