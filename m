Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab3B0PHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:07:40 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:60938 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3B0PHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:07:38 -0500
Date: Wed, 27 Feb 2013 07:07:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Wim Van Sebroeck <wim@iguana.be>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-watchdog@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [next-20130227] kernel NULL pointer dereference [ watchdog |
 perf related ? ]
Message-ID: <20130227150733.GB22383@htj.dyndns.org>
References: <CA+icZUUsedHPqZc5jXQ_AqAbfmTMu5WW8CJ+vnHwL69ofw7uTw@mail.gmail.com>
 <20130227122302.GA5678@pd.tnic>
 <CA+icZUVXDfOhztQtrOxyYaHutpx=iVpPGmRT0PzP7045_mjh6w@mail.gmail.com>
 <CA+icZUXJb5O7ML-xnQq8Zoa46NmaGZp2Xaqj6fJL+vudPeQTLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXJb5O7ML-xnQq8Zoa46NmaGZp2Xaqj6fJL+vudPeQTLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replying here too just in case.

On Wed, Feb 27, 2013 at 02:08:40PM +0100, Sedat Dilek wrote:
> >> static inline void *idr_find(struct idr *idr, int id)
> >> {
> >>         struct idr_layer *hint = rcu_dereference_raw(idr->hint);
> >>     86d7:       48 8b 05 00 00 00 00    mov    0x0(%rip),%rax        # 86de <perf_init_event+0x2e>
> >>                         86da: R_X86_64_PC32     .bss+0xfc
> >>
> >>         if ((id & ~IDR_MASK) == hint->prefix)
> >>     86de:       89 f2                   mov    %esi,%edx
> >>     86e0:       30 d2                   xor    %dl,%dl
> >>     86e2:       3b 10                   cmp    (%rax),%edx              <--- trapping insn
> >>     86e4:       74 4a                   je     8730 <perf_init_event+0x80>
> >>                 return rcu_dereference_raw(hint->ary[id & IDR_MASK]);
> >>
> >>
> >> So 'hint' is NULL as RAX above confirms and we're not supposed to deref
> >> NULL things.
> >>
> >> Looking at 29cf29e1fbb875019713eb55cf27ec35f1e5fa5e, Tejun should
> >> probably know. CCed.

Fix was posted some days ago.

  http://thread.gmane.org/gmane.linux.kernel.next/26213

I got Andrew's patch added to -mm message a week ago.  Not sure why it
still hasn't showed up.  Andrew, any ideas?

Thanks.

-- 
tejun
