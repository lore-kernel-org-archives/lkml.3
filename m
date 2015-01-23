Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbbAWJ6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:58:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbbAWJ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:57:58 -0500
Message-ID: <54C21ADE.1040605@redhat.com>
Date: Fri, 23 Jan 2015 10:56:46 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Fam Zheng <famz@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Miklos Szeredi <mszeredi@suse.cz>,
        David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
References: <1421747878-30744-1-git-send-email-famz@redhat.com> <1421747878-30744-6-git-send-email-famz@redhat.com> <54BE4F1D.7090807@gmail.com> <20150121045903.GA2858@fam-t430.nay.redhat.com> <54BF5ACE.6030206@gmail.com> <20150121085827.GB23024@ad.nay.redhat.com> <54BF814F.7090703@redhat.com> <20150121111404.GA3804@ad.nay.redhat.com> <54BF9294.3070902@redhat.com> <CALCETrWwuJpFK+38mBxxTQCu7Oig22Nr+mAuO++Y+0CdAhfzkw@mail.gmail.com>
In-Reply-To: <CALCETrWwuJpFK+38mBxxTQCu7Oig22Nr+mAuO++Y+0CdAhfzkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/01/2015 22:12, Andy Lutomirski wrote:
> In my application, the set of fds almost never changes, but the set of
> events I want changes all the time.  The main thing that changes is
> whether I care about EPOLLOUT.  If I'm ready to send something, then I
> want EPOLLOUT.  If I'm not ready, then I don't want EPOLLOUT.

Yes, this is almost always the case unless you use EPOLLET.

Paolo
