Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3CKUxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:53:25 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:58474 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab3CKUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:53:24 -0400
Date: Mon, 11 Mar 2013 17:53:16 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 00/12] perf annotate: Add support for event group view
 (v2)
Message-ID: <20130311205316.GA11779@ghostprotocols.net>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 05, 2013 at 02:53:20PM +0900, Namhyung Kim escreveu:
> This patchset implements event group view on perf annotate.  It's
> basically a rebased version and major difference to prior version is
> the GTK annotation browser support.

> Here goes an example:

>  $ perf annotate --group --stdio

>   crtstuff.c:0
>      8.08    2.40    5.29 :        387dc0aa50:   mov    %rdi,%rdx


I applied this series minus the TUI enabling one, as it is not working,
so right now my perf/core has --group --stdio and --group --gtk working,
please take a look at --group --tui.

I need to go thru this more thoroughly, as at least one thing caught my
attention, in some cases ->nr_pcnt is used and in others
evsel->nr_members, do we need both?

- Arnaldo
