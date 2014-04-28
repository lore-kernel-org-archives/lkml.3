Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbaD1Vzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:55:42 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:47892 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaD1Vzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:55:41 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxgW0fS=6xJsKP-WiOUw=aiCEvydj+pc+zDF8Pvn4v+Jw@mail.gmail.com>
References: <535EA976.1080402@linux.vnet.ibm.com>
	<CA+55aFxgW0fS=6xJsKP-WiOUw=aiCEvydj+pc+zDF8Pvn4v+Jw@mail.gmail.com>
Date: Mon, 28 Apr 2014 14:55:40 -0700
X-Google-Sender-Auth: uhktfIdJbqKlI2R2VDv85WIBLNM
Message-ID: <CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at mm/vmacache.c:85!
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 2:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That said, the bug does seem to be that some path doesn't invalidate
> the vmacache sufficiently, or something inserts a vmacache entry into
> the current process when looking up a remote process or whatever.
> Davidlohr, ideas?

Maybe we missed some use_mm() call. That will change the current mm
without flushing the vma cache. The code considers kernel threads to
be bad targets for vma caching for this reason (and perhaps others),
but maybe we missed something.

I wonder if we should just invalidate the vma cache in use_mm(), and
remote the "kernel tasks are special" check.

Srivatsa, are you doing something peculiar on that system that would
trigger this? I see some kdump failures in the log, anything else?

                 Linus
