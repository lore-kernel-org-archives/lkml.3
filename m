Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab3LJUQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:16:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab3LJUQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:16:52 -0500
Date: Tue, 10 Dec 2013 21:16:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/1] uprobes: Kill __replace_page(), change
	uprobe_write_opcode() to rely on gup(WRITE)
Message-ID: <20131210201650.GA679@redhat.com>
References: <20131209211824.GA15006@redhat.com> <CA+55aFxkW2cFB3us0_A+Nq04UYOq4H_ta5rNYyuYyZd=YOuk2w@mail.gmail.com> <20131210191837.GA30680@redhat.com> <CA+55aFxng2sriDQzt4w_=+ihUWms6jToXzDPymDRuowN8hCFKw@mail.gmail.com> <20131210200426.GA31862@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210200426.GA31862@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Oleg Nesterov wrote:
>
> On 12/10, Linus Torvalds wrote:
> >
> > We'd be *much* better off using get_user_pages_fast() if possible -
> > and I bet _is_ possible in 99% of all cases.
>
> We can't. get_user_pages_fast() takes mmap_sem.

Hmm. I am stupid, there is __get_user_pages_fast(). OK, I'll try
to think more.

Oleg.

