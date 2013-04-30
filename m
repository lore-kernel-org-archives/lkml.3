Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab3D3Q1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:27:16 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:59659 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760951Ab3D3Q1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130430162300.GB28821@gmail.com>
References: <20130430065808.GA19736@gmail.com>
	<CA+55aFwcX3oKYCFbq4XcX7Y2Yk6BWWKY4TRNOyfeZ9rYrQMRNQ@mail.gmail.com>
	<20130430153512.GA21930@redhat.com>
	<20130430162300.GB28821@gmail.com>
Date: Tue, 30 Apr 2013 09:27:12 -0700
X-Google-Sender-Auth: uAX0lju3XubxxkBulTMIykDGG0U
Message-ID: <CA+55aFwsv+p3wqx5eMr3iNPxmPZhSx-h5s5R7s9yd314Muajvg@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler changes for v3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Fr?d?ric Weisbecker" <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 9:23 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Linus, would you like me to revert d9a3c9823a2e and re-send the pull
> request?

I took the pull request, but I'd like to see the non-64-bit divide
version before the merge window ends. And with no more div_rem users I
think we should at least double-check that the new div64_u64() (that
uses the new div64_u64_rem) isn't noticeably slower than the old one.
If it is, we should revert that new (and then unused) div64 code too.

              Linus
