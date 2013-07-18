Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3GRARi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:17:38 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:45788 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807Ab3GRARh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:17:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130717234049.GC3572@sgi.com>
References: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard>
	<20130716193332.GB3572@sgi.com>
	<CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
	<CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
	<20130717040616.GI11674@dastard>
	<CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
	<20130717055103.GK11674@dastard>
	<CA+55aFxdqzMY5VJoYaLmL=+=f2s1cbHHV-TjC3=taXpF-xov1w@mail.gmail.com>
	<20130717234049.GC3572@sgi.com>
Date: Wed, 17 Jul 2013 17:17:36 -0700
X-Google-Sender-Auth: p9oBxSd30hGIUrJdx_nicD_D4SM
Message-ID: <CA+55aFy-8QH4bTW7hU=381tuEWgHC=PUM6WP3qn-ooge=7M0QQ@mail.gmail.com>
Subject: Re: splice vs execve lockdep trace.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ben Myers <bpm@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 4:40 PM, Ben Myers <bpm@sgi.com> wrote:
>>
>> We're still talking at cross purposes then.
>>
>> How the hell do you handle mmap() and page faulting?
>
> __xfs_get_blocks serializes access to the block map with the i_lock on the
> xfs_inode.  This appears to be racy with respect to hole punching.

Would it be possible to just make __xfs_get_blocks get the i_iolock
(non-exclusively)?

Or, alternatively, do it in the readpage() function?

That was what I thought you did anyway. Exactly because of the whole
page faulting issue.

                   Linus
