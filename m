Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbaGQT40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:56:26 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:45345 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbaGQT4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:56:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140717173433.GQ1491@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org> <20140717170115.GO1491@thunk.org>
 <CAComcpM9-sUwzT9BPFT7BJjk97V0kj996D=AaivDpeTZUNbiew@mail.gmail.com> <20140717173433.GQ1491@thunk.org>
From: Bob Beck <beck@openbsd.org>
Date: Thu, 17 Jul 2014 13:56:03 -0600
X-Google-Sender-Auth: mxVQO_7TdFraksLVzzd9KUxFABo
Message-ID: <CAComcpPO1hrcfpe+Pmy2jtVE=dVU1S+=ZsVotuBzZEVOivwwvA@mail.gmail.com>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
To: "Theodore Ts'o" <tytso@mit.edu>, Bob Beck <beck@openbsd.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-abi <linux-abi@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ted, one more nit. Yes, I have a bicycle too..

I see here we add a flag to make it block - whereas it seems most
other system calls that can block the flag is
added to make it not block (I.E. O_NONBLOCK, etc. etc.)  Would it make
more sense to invert this so it was more
like the typical convention in other system calls?


On Thu, Jul 17, 2014 at 11:34 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 17, 2014 at 11:05:01AM -0600, Bob Beck wrote:
>> Hi Ted, yeah I understand the reasoning, it would be good if there was
>> a way to influence the various libc people to
>> ensure they manage to provide a getentropy().
>
> I don't anticipate that to be a problem.  And before they do, and/or
> if you are dealing with a system where the kernel has been upgraded,
> but not libc, you have your choice of either sticking with the
> binary_sysctl approach, or calling getrandom directly using the
> syscall method; and in that case, whether we use getrandom() or
> provide an exact getentropy() replacement system call isn't that much
> difference, since you'd have to have Linux-specific workaround code
> anyway....
>
>                                 - Ted
