Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762716Ab3DCKKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:10:44 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56290 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760461Ab3DCKKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <1364192494-22185-1-git-send-email-minchan@kernel.org>
References: <1364192494-22185-1-git-send-email-minchan@kernel.org>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Wed, 3 Apr 2013 12:10:22 +0200
X-Google-Sender-Auth: oroW2cfbspseVKXg1OvPdfvE8TM
Message-ID: <CAHO5Pa0srsWS6ukpxUo=EqCOxRmYa7c_7PDg1YPh7gcMGWPpaw@mail.gmail.com>
Subject: Re: [RFC 1/4] mm: Per process reclaim
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Sangseok Lee <sangseok.lee@lge.com>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Minchan,

On Mon, Mar 25, 2013 at 7:21 AM, Minchan Kim <minchan@kernel.org> wrote:
> These day, there are many platforms avaiable in the embedded market
> and they are smarter than kernel which has very limited information
> about working set so they want to involve memory management more heavily
> like android's lowmemory killer and ashmem or recent many lowmemory
> notifier(there was several trial for various company NOKIA, SAMSUNG,
> Linaro, Google ChromeOS, Redhat).
>
> One of the simple imagine scenario about userspace's intelligence is that
> platform can manage tasks as forground and backgroud so it would be
> better to reclaim background's task pages for end-user's *responsibility*
> although it has frequent referenced pages.
>
> This patch adds new knob "reclaim under proc/<pid>/" so task manager
> can reclaim any target process anytime, anywhere. It could give another
> method to platform for using memory efficiently.
>
> It can avoid process killing for getting free memory, which was really
> terrible experience because I lost my best score of game I had ever
> after I switch the phone call while I enjoyed the game.
>
> Writing 1 to /proc/pid/reclaim reclaims only file pages.
> Writing 2 to /proc/pid/reclaim reclaims only anonymous pages.
> Writing 3 to /proc/pid/reclaim reclaims all pages from target process.

This interface seems to work as advertized, at least from some light
testing that I've done.

However, the interface is a quite blunt instrument. Would there be any
virtue in extending it so that an address range could be written to
/proc/PID/reclaim? Used in conjunction with /proc/PID/maps, a manager
process might then choose to trigger reclaim of just selected regions
of a processes address space. Thus, one might reclaim file backed
pages in a range using:

    echo '2 start-address end-address' > /proc/PID/reclaim

What do you think?

Thanks,

Michael
