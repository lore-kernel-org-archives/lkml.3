Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3J1Fwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:52:36 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57948 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3J1Fwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:52:35 -0400
X-AuditID: 9c93017d-b7c97ae000000e9f-35-526dfba16db4
From: Namhyung Kim <namhyung@kernel.org>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH rebase] perf/ui/tui: don't force a refresh during progress update
References: <1382565562-15108-1-git-send-email-patrick@parcs.ath.cx>
	<1382747149-9716-1-git-send-email-patrick@parcs.ath.cx>
Date: Mon, 28 Oct 2013 14:52:33 +0900
In-Reply-To: <1382747149-9716-1-git-send-email-patrick@parcs.ath.cx> (Patrick
	Palka's message of "Fri, 25 Oct 2013 20:25:49 -0400")
Message-ID: <87wqky7xi6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Patrick,

On Fri, 25 Oct 2013 20:25:49 -0400, Patrick Palka wrote:
> Each call to tui_progress__update() would forcibly refresh the entire
> screen.  This is somewhat inefficient and causes noticable flickering
> during the startup of perf-report, especially on large/slow terminals.
>
> It looks like the force-refresh in tui_progress__update() serves no
> purpose other than to clear the screen so that the progress bar of a
> previous operation does not subsume that of a subsequent operation.
> But we can do just that in a much more efficient manner by clearing only
> the region that a previous progress bar may have occupied before
> repainting the new progress bar.  Then the force-refresh could be
> removed with no change in visuals.
>
> This patch disables the slow force-refresh in tui_progress__update() and
> instead calls SLsmg_fill_region() on the entire area that the progress
> bar may occupy before repainting it.  This change makes the startup of
> perf-report much faster and appear much "smoother".
>
> It turns out that this was a big bottleneck in the startup speed of
> perf-report -- with this patch, perf-report starts up ~2x faster (1.1s
> vs 0.55s) on my machines.  (These numbers were measured by running
> "time perf report" on an 8MB perf.data and pressing 'q' immediately.)

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
