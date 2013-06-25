Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3FYAaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 20:30:15 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58426 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3FYAaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 20:30:13 -0400
Date: Tue, 25 Jun 2013 02:30:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf sort: Separate out memory-specific sort
 keys
Message-ID: <20130625003010.GU6123@two.firstfloor.org>
References: <1364991979-3008-3-git-send-email-namhyung@kernel.org>
 <tip-afab87b91f3f331d55664172dad8e476e6ffca9d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-afab87b91f3f331d55664172dad8e476e6ffca9d@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 04:20:20AM -0700, tip-bot for Namhyung Kim wrote:
> perf sort: Separate out memory-specific sort keys
> 
> Since they're used only for perf mem, separate out them to a different
> dimension so that normal user cannot access them by any chance.
> 
> For global/local weights, I'm not entirely sure to place them into the
> memory dimension.  But it's the only user at this time.

So I was finally able to test with this patch, but 
I found it completely breaks TSX weight abort profiling.

It uses weight (global/local), but it's not 
running in memory mode.

I'll send a patch to move weight back into
the common keys.

-Andi

