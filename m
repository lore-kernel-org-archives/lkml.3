Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaJCU4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:56:36 -0400
Received: from mx5-phx2.redhat.com ([209.132.183.37]:35526 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaJCU4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:56:32 -0400
Date: Fri, 3 Oct 2014 16:55:50 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, qemu-devel@nongnu.org,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\Dr. David Alan Gilbert" <dgilbert@redhat.com>,
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
Message-ID: <357882411.58338047.1412369750145.JavaMail.zimbra@redhat.com>
In-Reply-To: <CA+55aFwEO9=ieSb0uipfQ+qP9nP1ps=NCTe0HL9arK1cRYaJPg@mail.gmail.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com> <1412356087-16115-2-git-send-email-aarcange@redhat.com> <CA+55aFwEO9=ieSb0uipfQ+qP9nP1ps=NCTe0HL9arK1cRYaJPg@mail.gmail.com>
Subject: Re: [PATCH 01/17] mm: gup: add FOLL_TRIED
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF32 (Linux)/8.0.6_GA_5922)
Thread-Topic: add FOLL_TRIED
Thread-Index: k0u9A3OccmrkZ0VNl5ADbarBwbJGOw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This needs more explanation than that one-liner comment. Make the
> commit message explain why the new FOLL_TRIED flag exists.

This patch actually is extracted from a 3.18 commit in the KVM tree,
https://git.kernel.org/cgit/virt/kvm/kvm.git/commit/?h=next&id=234b239b.

Here is how that patch uses the flag:

    /*
     * The previous call has now waited on the IO. Now we can
     * retry and complete. Pass TRIED to ensure we do not re
     * schedule async IO (see e.g. filemap_fault).
     */
    down_read(&mm->mmap_sem);
    npages = __get_user_pages(tsk, mm, addr, 1, flags | FOLL_TRIED,
                              pagep, NULL, NULL);
