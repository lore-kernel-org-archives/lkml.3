Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbaD1WjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:39:18 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:53821 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaD1WjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:39:17 -0400
Message-ID: <1398724754.25549.35.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [BUG] kernel BUG at mm/vmacache.c:85!
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Date: Mon, 28 Apr 2014 15:39:14 -0700
In-Reply-To: <CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com>
References: <535EA976.1080402@linux.vnet.ibm.com>
	 <CA+55aFxgW0fS=6xJsKP-WiOUw=aiCEvydj+pc+zDF8Pvn4v+Jw@mail.gmail.com>
	 <CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Oleg.

On Mon, 2014-04-28 at 14:55 -0700, Linus Torvalds wrote:
> On Mon, Apr 28, 2014 at 2:20 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > That said, the bug does seem to be that some path doesn't invalidate
> > the vmacache sufficiently, or something inserts a vmacache entry into
> > the current process when looking up a remote process or whatever.
> > Davidlohr, ideas?
> 
> Maybe we missed some use_mm() call. That will change the current mm
> without flushing the vma cache. The code considers kernel threads to
> be bad targets for vma caching for this reason (and perhaps others),
> but maybe we missed something.
> 
> I wonder if we should just invalidate the vma cache in use_mm(), and
> remote the "kernel tasks are special" check.
> 
> Srivatsa, are you doing something peculiar on that system that would
> trigger this? I see some kdump failures in the log, anything else?

Is this perhaps a KVM guest? fwiw I see CONFIG_KVM_ASYNC_PF=y which is a
user of use_mm().

