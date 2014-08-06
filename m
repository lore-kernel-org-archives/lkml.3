Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaHFS7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:59:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56265 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756284AbaHFS7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:59:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mel Gorman <mgorman@suse.de>
Cc: Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Nicolas Pitre <nico@linaro.org>, Mike Galbraith <mgalbraith@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Reduce overhead of menu governor
Date: Wed, 06 Aug 2014 21:17:45 +0200
Message-ID: <3495244.HqlX2f8Ijd@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1407331161-4642-1-git-send-email-mgorman@suse.de>
References: <1407331161-4642-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 06, 2014 02:19:17 PM Mel Gorman wrote:
> The menu_select function is heavy and is very noticable in profiles for
> workloads that enter/leave idle state a lot. This primarily happens
> for scheduler microbenchmarks. The biggest contibution is the standard
> deviation calculations and comparisons but the excessive calls into
> the scheduler core do not help.
> 
> It would be nice to reduce the number of times nr_iowait is checked to
> once per 8 intervals but I was not sure how to measure what the general
> impact of such a change could be.
> 
> Similiarly I looked at different ways the standard deviation could be
> calculated but the standard equivalent calculations potentially overflow.
> It could be done as rolling average and rolling deviation but again
> it was unclear how that could be evaluated. Tips on how the goodness/badness
> of governor changes are evalated would be nice.
> 
> In the meantime, here are patches against some  of the obvious stuff.

They look good, I'm going to apply them.

Rafael

