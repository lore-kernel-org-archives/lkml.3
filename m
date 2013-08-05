Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3HEIQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:16:47 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:42106 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab3HEIQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:16:45 -0400
Date: Mon, 5 Aug 2013 10:16:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130805081641.GA24808@gmail.com>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> By default perf currently links with the GTK2 gui. This pulls
> in a lot of external libraries. It also causes dependency
> problems for distribution packages: simply installing perf
> requires pulling in GTK2 with all its dependencies.
> 
> I think the UI is valuable, but it shouldn't be everywhere.
> 
> The interfaces between the main perf and the GTK2 perf are
> already quite clean, so it's very straight forward to just
> add a few weak stubs and then generate two executables:
> perf and perfgtk
> 
> The only difference is that the gtk version links in the
> GTK code and overrides the weak stubs.
> (so everything is still only compiled once)
> 
> I currently gave it the preliminary name "perfgtk".
> 
> This cuts down the library dependencies on the main perf
> dramatically. It also completely eliminates the GTK2_SUPPORT
> ifdef.
> 
> % ldd ./perf | wc -l
> 18
> % ldd ./perfgtk | wc -l
> 53

If you want fewer dependencies then build with 'make NO_GTK=1'.

Furthermore, what really matters in practice is binary size - and the GKT 
UI frontend code isn't really big:

 comet:~/tip/tools/perf> ls -l perf.gtk perf.nogtk
 -rwxrwxr-x 1 mingo mingo 2525416 Aug  5 10:09 perf.gtk.stripped
 -rwxrwxr-x 1 mingo mingo 2497480 Aug  5 10:09 perf.nogtk.stripped

that's only a 1% difference ...

So this is not a good idea, as it breaks the single binary structure of 
perf, which is a rather powerful concept that has served us really well in 
the past.

Thanks,

	Ingo
