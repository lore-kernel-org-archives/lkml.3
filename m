Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434Ab3DCLB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:01:27 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:63694 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760388Ab3DCLBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:01:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130403075017.GA2534@suse.de>
References: <20130403075017.GA2534@suse.de>
Date: Wed, 3 Apr 2013 13:01:23 +0200
Message-ID: <CAFTL4hyYezB2ZxM-GJ70VoxOeRSG64V6u+nX2hTuhF30R-GdPg@mail.gmail.com>
Subject: Re: systemtap broken by removal of register_timer_hook
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/3 Mel Gorman <mgorman@suse.de>:
> Commit ba6fdda4 (profiling: Remove unused timer hook) removed
> [un]register_timer_hook due to a lack of upstream users and a belief
> that there were no out-of-tree users. However, systemtap uses it and
> with that patch applied, some stap scripts fail with
>
> WARNING: "unregister_timer_hook" [/tmp/stapJoLMxD/stap_de6e19eaf7bd94629aba9d6f56cdfca5_8156.ko] undefined!
> WARNING: "register_timer_hook" [/tmp/stapJoLMxD/stap_de6e19eaf7bd94629aba9d6f56cdfca5_8156.ko] undefined!
> Error inserting module '/tmp/stapJoLMxD/stap_de6e19eaf7bd94629aba9d6f56cdfca5_8156.ko': Unknown symbol in module
> WARNING: /usr/bin/staprun exited with status: 1
> Pass 5: run failed.  Try again with another '--vp 00001' option.
> Unexpected exit of STAP script at ./watch-dstate.pl line 305.

Ah I missed that.

>
> Can the patch be reverted or at least put a warning in place about it
> being obsoleted until the systemtap folks come up with a replacement?

Sometimes I don't mind keeping around code in the kernel for out of
tree users, depending on the case. But in this specific matter we have
more standard ways to do this kind of hook: kprobes, static
tracepoints. A tracepoint on the timer tick would be useful BTW, and
you could reuse it.

How does that sound to system tap guys? It would be nice if we can
avoid the feature-removal.txt step. I mean, I heard some doleful
whispers once when my pointer selected that file. Instead of opening
the file I just closed the directory instantly. I never told anybody
about that before, this is the first time. I also heard that somebody
added an entry to that file to schedule the removal of that file? This
is devilry.
