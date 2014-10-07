Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaJGMsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:48:04 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40994 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbaJGMsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <20141006164156.GA31075@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
	<1412356087-16115-11-git-send-email-aarcange@redhat.com>
	<CA+55aFx++R42L75ooE=Fmaem73=V=q7f6pYTcALxgrA1y98G-A@mail.gmail.com>
	<20141006085540.GD2336@work-vm>
	<20141006164156.GA31075@redhat.com>
Date: Tue, 7 Oct 2014 08:47:59 -0400
X-Google-Sender-Auth: Tyzk1tV9O0TQwTHAjo42veSTmZY
Message-ID: <CA+55aFxAOYBny+QwXfkPy-P3rs-RPr5SLYLcPNBiFO3waBXtQA@mail.gmail.com>
Subject: Re: [PATCH 10/17] mm: rmap preparation for remap_anon_pages
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2014 at 12:41 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> Of course if somebody has better ideas on how to resolve an anonymous
> userfault they're welcome.

So I'd *much* rather have a "write()" style interface (ie _copying_
bytes from user space into a newly allocated page that gets mapped)
than a "remap page" style interface

remapping anonymous pages involves page table games that really aren't
necessarily a good idea, and tlb invalidates for the old page etc.
Just don't do it.

           Linus
