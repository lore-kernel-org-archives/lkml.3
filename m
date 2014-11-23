Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaKWSiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:38:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44529 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaKWSiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:38:21 -0500
Date: Sun, 23 Nov 2014 19:38:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>
Subject: Re: task_stat splat
Message-ID: <20141123183818.GA6032@pd.tnic>
References: <20141123111220.GA6436@pd.tnic>
 <20141123172256.GA9625@redhat.com>
 <20141123175641.GA11619@redhat.com>
 <20141123181717.GA13198@redhat.com>
 <20141123182108.GA15349@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141123182108.GA15349@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 07:21:08PM +0100, Oleg Nesterov wrote:
> > Perhaps this is migration thread? stop_sched_class doesn't have ->update_curr.
> 
> Yes, I think this can explain the problem, but
> 
> > could you try to cat /proc/pid-of-migration-thread/stat on your machine?
> 
> This won't trigger the crash unless it is running.

This ?

$ for pid in $(pgrep migration); do cat /proc/$pid/stat; done
10 (migration/0) S 2 0 0 0 -1 69238848 0 0 0 0 0 10 0 0 -100 0 1 0 8 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 0 99 1 0 0 0 0 0 0 0 0 0 0 0
13 (migration/1) S 2 0 0 0 -1 69238848 0 0 0 0 0 4 0 0 -100 0 1 0 9 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 1 99 1 0 0 0 0 0 0 0 0 0 0 0
18 (migration/2) S 2 0 0 0 -1 69238848 0 0 0 0 0 4 0 0 -100 0 1 0 11 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 2 99 1 0 0 0 0 0 0 0 0 0 0 0
23 (migration/3) S 2 0 0 0 -1 69238848 0 0 0 0 0 10 0 0 -100 0 1 0 14 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 3 99 1 0 0 0 0 0 0 0 0 0 0 0
28 (migration/4) S 2 0 0 0 -1 69238848 0 0 0 0 0 4 0 0 -100 0 1 0 16 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 4 99 1 0 0 0 0 0 0 0 0 0 0 0
33 (migration/5) S 2 0 0 0 -1 69238848 0 0 0 0 0 11 0 0 -100 0 1 0 19 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 5 99 1 0 0 0 0 0 0 0 0 0 0 0
38 (migration/6) S 2 0 0 0 -1 69238848 0 0 0 0 0 10 0 0 -100 0 1 0 21 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 6 99 1 0 0 0 0 0 0 0 0 0 0 0
43 (migration/7) S 2 0 0 0 -1 69238848 0 0 0 0 0 6 0 0 -100 0 1 0 23 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 7 99 1 0 0 0 0 0 0 0 0 0 0 0

It doesn't trigger, of course, as I've reverted the patch. Second resume
looks ok.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
