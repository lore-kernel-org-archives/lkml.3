Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab3GLJjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:39:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64750 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab3GLJjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:39:17 -0400
Date: Fri, 12 Jul 2013 10:39:09 +0100
From: Robert Richter <rric@kernel.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf tools: Fix build errors with O and
 DESTDIR make vars set
Message-ID: <20130712093909.GD8731@rric.localhost>
References: <1370964158-4135-1-git-send-email-rric@kernel.org>
 <tip-107de3724eff5a6fa6474a4d2aa5460b63749ebf@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-107de3724eff5a6fa6474a4d2aa5460b63749ebf@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.07.13 01:49:40, tip-bot for Robert Richter wrote:
> Commit-ID:  107de3724eff5a6fa6474a4d2aa5460b63749ebf
> Gitweb:     http://git.kernel.org/tip/107de3724eff5a6fa6474a4d2aa5460b63749ebf
> Author:     Robert Richter <robert.richter@linaro.org>
> AuthorDate: Tue, 11 Jun 2013 17:22:38 +0200
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Mon, 8 Jul 2013 17:34:00 -0300
> 
> perf tools: Fix build errors with O and DESTDIR make vars set
> 
> Fixing build errors with O and DESTDIR make vars set:
> 
>  $ make prefix=/usr/local O=$builddir DESTDIR=$destdir -C tools/ perf
>  ...
>  make[1]: Entering directory `.../.source/perf/tools/perf'
>      CC .../.build/perf/perf/util/parse-events.o
>  util/parse-events.c:14:32: fatal error: parse-events-bison.h: No such file or directory
>  compilation terminated.
>  make[1]: *** [.../.build/perf/perf/util/parse-events.o] Error 1
>  ...

Boris just raised another variant of building perf tools, which
unfortunately is broken now:

 $ make tools/perf
     LINK /home/robert/cx/linux/tools/perf/perf
 gcc: error: ../linux/tools/lib/lk/liblk.a: No such file or directory

There is also

 $ make -C tools perf
 $ make -C tools/perf

Plus variants with O= and DESTDIR set.

Looking how to fix this...

-Robert
