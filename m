Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaJCSbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:31:37 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:51528 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaJCSbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:31:32 -0400
MIME-Version: 1.0
In-Reply-To: <1412356087-16115-11-git-send-email-aarcange@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
	<1412356087-16115-11-git-send-email-aarcange@redhat.com>
Date: Fri, 3 Oct 2014 11:31:31 -0700
X-Google-Sender-Auth: rBBK7Hn9L9RSfElSb7zwFL8sC0U
Message-ID: <CA+55aFx++R42L75ooE=Fmaem73=V=q7f6pYTcALxgrA1y98G-A@mail.gmail.com>
Subject: Re: [PATCH 10/17] mm: rmap preparation for remap_anon_pages
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: qemu-devel@nongnu.org, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\Dr. David Alan Gilbert\\" <dgilbert@redhat.com>,
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

On Fri, Oct 3, 2014 at 10:08 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> Overall this looks a fairly small change to the rmap code, notably
> less intrusive than the nonlinear vmas created by remap_file_pages.

Considering that remap_file_pages() was an unmitigated disaster, and
-mm has a patch to remove it entirely, I'm not at all convinced this
is a good argument.

We thought remap_file_pages() was a good idea, and it really really
really wasn't. Almost nobody used it, why would the anonymous page
case be any different?

            Linus
