Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268Ab3BMT4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:56:53 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:58168 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab3BMT4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:56:52 -0500
MIME-Version: 1.0
In-Reply-To: <20130213193411.GA15928@redhat.com>
References: <20130212193901.GA18906@redhat.com> <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com> <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Feb 2013 11:56:25 -0800
X-Google-Sender-Auth: Qh-zm7GRuuRe9TTQilTX52SBPRk
Message-ID: <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
To: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 11:34 AM, Dave Jones <davej@redhat.com> wrote:
>
> My test was a loop of 100 suspend/resume cycles before calling something
> 'good'. The 'bad' cases all failed within 10 cycles (usually 2-3).

Considering that you apparently already found one case where the BIOS
crapped out due to effectively unrelated timing details (ie timing
triggered a temperature issue that then triggered behavioral changes),
I wonder if your more occasional problem might not be a sign of
something similar.

But since you seem to be able to automate it well, maybe one thing to
try is to change the timing a bit while testing. Maybe some failures
were hidden by the timing just happening to work out.

Also, as I suspect you're aware: since the "bad" markings for "git
bisect" are presumably reliable (with the caveat that you need to
worry about the exact symptoms and not mix it up with some other
independent bug, as you already found out), you can usually speed up
repeated bisects by using the last bad information from the previous
bisect.

Note that there is only ever one "bad" commit - since all the commits
you test while bisecting are by definition reachable from the previous
bad one and both contain the bug, picking a bad commit makes all other
previous bad commits uninteresting. So you just need to look at the
last bad commit, not the whole set of bad commits. So when re-doing
the bisect, and if you trust that your bad kernels really were bad and
had the *right* badness, you can just start with "git bisect bad
<last-bad-commit>"

(good commits, on the other hand, are independent of each other: "not
containing the bug" is not some kind of exclusivity test, so finding
one good kernel doesn't make the information about other good kernels
irrelevant)

                 Linus
