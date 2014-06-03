Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaFCTOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbaFCTOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:14:07 -0400
Date: Tue, 3 Jun 2014 21:13:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes/x86: Rename arch_uprobe->def into ->dflt,
	minor comment updates
Message-ID: <20140603191315.GA32736@redhat.com>
References: <20140601192520.GA14539@redhat.com> <20140603182142.GA5097@gmail.com> <20140603183057.GA31382@redhat.com> <20140603183919.GC7664@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603183919.GC7664@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > And this is how it was named when I wrote this code. Unfortunately gcc
> > dislikes this name ;) So I renamed it to ->def. Then I was asked to
> > rename it and I agree, ->def doesn't look good.
> >
> > Could you suggest something better?
>
> So exactly what do those fields do? If it's scratch register handling,
> would it be logical to name it arch_uprobe->scratch, or so?

Not only, ->fixups encodes other flags. and ->ilen is used by UPROBE_FIX_CALL.

arch_uprobe->def contains the arguments for default_xol_ops methods, currently
this handles everything except relative jmp/call insns.

So perhaps ->dflt is not that ugly in this case? I simply do not see anything
better. But again, I agree with any name in advance.

Oleg.

