Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbaJ2R50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:57:26 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:44209 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaJ2R5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <20141029174607.GK19606@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <544E1143.1080905@huawei.com> <20141029174607.GK19606@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 29 Oct 2014 17:56:59 +0000
Message-ID: <CAFEAcA9JNVsT57Zgy96+cfdWBABE4_g4yJG7Te8Oa8ReXZqeRQ@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH 00/17] RFC: userfault v2
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: zhanghailiang <zhang.zhanghailiang@huawei.com>,
        Robert Love <rlove@google.com>, Dave Hansen <dave@sr71.net>,
        Jan Kara <jack@suse.cz>, kvm-devel <kvm@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, Stefan Hajnoczi <stefanha@gmail.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, Taras Glek <tglek@mozilla.com>,
        Andrew Jones <drjones@redhat.com>, Juan Quintela <quintela@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>, Mel Gorman <mgorman@suse.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Android Kernel Team <kernel-team@android.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Christopher Covington <cov@codeaurora.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Paolo Bonzini <pbonzini@redhat.com>, Keith Packard <keithp@keithp.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Minchan Kim <minchan@kernel.org>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mike Hommey <mh@glandium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 October 2014 17:46, Andrea Arcangeli <aarcange@redhat.com> wrote:
> After some chat during the KVMForum I've been already thinking it
> could be beneficial for some usage to give userland the information
> about the fault being read or write

...I wonder if that would let us replace the current nasty
mess we use in linux-user to detect read vs write faults
(which uses a bunch of architecture-specific hacks including
in some cases "look at the insn that triggered this SEGV and
decode it to see if it was a load or a store"; see the
various cpu_signal_handler() implementations in user-exec.c).

-- PMM
