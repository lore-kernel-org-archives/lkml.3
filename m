Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab3GRMTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:19:32 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:63589 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255Ab3GRMTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:19:30 -0400
Date: Thu, 18 Jul 2013 14:19:24 +0200
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix 'make tools/perf'
Message-ID: <20130718121924.GL8731@rric.localhost>
References: <1370964158-4135-1-git-send-email-rric@kernel.org>
 <tip-107de3724eff5a6fa6474a4d2aa5460b63749ebf@git.kernel.org>
 <20130712093909.GD8731@rric.localhost>
 <20130716145036.GH8731@rric.localhost>
 <20130717153118.GC2071@ghostprotocols.net>
 <20130717154001.GA4454@pd.tnic>
 <20130717161051.GJ8731@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717161051.GJ8731@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

I noticed you applied the patch to acme/perf/core, but it should be
instead in urgent since mainline is broken.

On 17.07.13 18:10:51, Robert Richter wrote:
> On 17.07.13 17:40:01, Borislav Petkov wrote:
> > On Wed, Jul 17, 2013 at 12:31:18PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Humm, probably it will look at the top level 'install' target? There
> > > was some discussion about this, right? Can you refresh my mind?

Now tested with:

 make O=... DESTDIR=... tools/perf
 make O=... DESTDIR=... tools/perf_install
 make O=... DESTDIR=... -C tools/ perf
 make O=... DESTDIR=... -C tools/ perf_install
 make O=... DESTDIR=... -C tools/perf
 make O=... DESTDIR=... -C tools/perf install
 make tools/perf
 make DESTDIR=... tools/perf_install
 make -C tools/ perf
 make -C tools/ DESTDIR=... perf_install
 make -C tools/perf
 make -C tools/perf DESTDIR=... install

No issues noticed, accept that doc is built when running the 'install'
target, not 'all'.

Will look at this.

We also should remove dependencies from install targets that trigger a
rebuild since 'make install' is run as root. I had a conversation with
Linus about this for building the arm kernel, but the same applies
also for perf tools. I don't have the time for changing this now, but
maybe in some weeks or so.

Thanks,

-Robert
