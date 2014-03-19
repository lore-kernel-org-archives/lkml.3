Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbaCSBKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:10:43 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:51476 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530AbaCSBKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1403181703470.7055@eggly.anvils>
References: <20140311045109.GB12551@redhat.com>
	<20140310220158.7e8b7f2a.akpm@linux-foundation.org>
	<20140311053017.GB14329@redhat.com>
	<20140311132024.GC32390@moon>
	<531F0E39.9020100@oracle.com>
	<20140311134158.GD32390@moon>
	<20140311142817.GA26517@redhat.com>
	<20140311143750.GE32390@moon>
	<20140311171045.GA4693@redhat.com>
	<20140311173603.GG32390@moon>
	<20140311173917.GB4693@redhat.com>
	<alpine.LSU.2.11.1403181703470.7055@eggly.anvils>
Date: Tue, 18 Mar 2014 18:10:40 -0700
X-Google-Sender-Auth: 81iQZDOAwP_n-mD3nFJttN6fI8s
Message-ID: <CA+55aFx0ZyCVrkosgTongBrNX6mJM4B8+QZQE1p0okk8ubbv7g@mail.gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bob Liu <bob.liu@oracle.com>, Konstantin Khlebnikov <koct9i@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 5:38 PM, Hugh Dickins <hughd@google.com> wrote:
>
> And yes, it is possible (though very unusual) to find an anon page or
> swap entry in a VM_SHARED nonlinear mapping: coming from that horrid
> get_user_pages(write, force) case which COWs even in a shared mapping.

Hmm. Maybe we could just disallow that forced case.

It *used* to be a trivial "we can just do a COW", but that was back
when the VM was much simpler and we had no rmap's etc. So "that horrid
case" used to be a simple hack that wasn't painful. But I suspect we
could very easily just fail it instead of forcing a COW, if that would
make it simpler for the VM code.

               Linus
