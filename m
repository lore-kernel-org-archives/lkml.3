Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850Ab3D3PVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:21:46 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:35692 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760816Ab3D3PVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130430074322.GA20110@gmail.com>
References: <20130430074322.GA20110@gmail.com>
Date: Tue, 30 Apr 2013 08:21:42 -0700
X-Google-Sender-Auth: T_u3QSOKZnKWNJGeAavQfQMejE8
Message-ID: <CA+55aFwaQMjKDV5aA=_2mNiF1msGZO2hX3gypCZTByzDZxX6DQ@mail.gmail.com>
Subject: Re: [GIT PULL] timer changes for v3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 12:43 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest timers-core-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

Hmm.. The "Use generic idle loop" patches from the SMP/hotplug pull
conflicted with the "Use tick broadcast expired check" patches in this
one for both x86 and ARM.

Both sets of patches were done by Thomas, and I *really* want you guys
to take a look at my conflict resolution. I effectively moved the new
"don't go into deep idle if boradcast timer is pending" check from x86
and arm into the generic idle loop. So my merge resolution is
semantically quite different  from either branch, but the alternative
seemed to be to remove the new check entirely.

I pushed my merge out, please take a look.

                      Linus
