Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab3EXTx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 15:53:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab3EXTxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 15:53:25 -0400
Date: Fri, 24 May 2013 12:53:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] coredump: kill call_count, add core_name_size
Message-Id: <20130524125323.861541a12992c3da0145f0d9@linux-foundation.org>
In-Reply-To: <20130515201232.GA14648@redhat.com>
References: <20130515201158.GA14606@redhat.com>
	<20130515201232.GA14648@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013 22:12:32 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> Imho, "atomic_t call_count" is ugly and should die. It buys
> nothing and in fact it can grow more than necessary, expand
> doesn't check if it was already incremented by another task.
> 
> Kill it, and introduce "static int core_name_size" updated by
> expand_corename(). This is obviously racy too but harmless,
> and core_name_size never grows for no reason.
> 
> We do not bother to to calculate the "right" new size, we
> simply do kmalloc(size_we_need) and use ksize() to rely on
> kmalloc_index's decision.
> 
> Finally change format_corename() to use expand_corename(),
> krealloc(NULL) is fine.

The code still looks like a bunch of fluff.  I look at it and think
"wtf, why doesn't it just use kasprintf()". 

If there were any comments in there at all which explained the reason
for the code's existence, perhaps I wouldn't think that.  But there
aren't, so I do.

