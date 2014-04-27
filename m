Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaD0NN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 09:13:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaD0NN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 09:13:27 -0400
Date: Sun, 27 Apr 2014 15:13:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC PATCH] uprobes: simplify rip-relative handling
Message-ID: <20140427131318.GA25295@redhat.com>
References: <1398533370-8865-1-git-send-email-dvlasenk@redhat.com> <1398533370-8865-2-git-send-email-dvlasenk@redhat.com> <20140427113040.GA17908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140427113040.GA17908@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Oleg Nesterov wrote:
>
> On 04/26, Denys Vlasenko wrote:
> >
> > @@ -46,7 +46,7 @@ struct arch_uprobe {
> >
> >  	union {
> >  #ifdef CONFIG_X86_64
> > -		unsigned long			rip_rela_target_address;
> > +		int				insn_length;
> >  #endif
>
> in particular, we already have auprobe->def.ilen this patch can use.

And I forgot to mention...

I can easily misunderstand the change in handle_riprel_insn(), but it
seems that since you removed memmove(cursor, ...) the changed insn has
the same lenghth as the original insn?

If yes,

	- the patch is wrong, it breaks the "correction" logic

	- but, at the same time, we can simplify this logic and
	  just kill the "long *correction" arg of riprel_post_xol.

Oleg.

