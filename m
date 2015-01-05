Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbbAEK55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:57:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35616 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbbAEK5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:57:53 -0500
Date: Mon, 5 Jan 2015 11:57:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/30] perf tools: Add new build framework support
Message-ID: <20150105105751.GB19655@pd.tnic>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
 <1420212972-21595-2-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420212972-21595-2-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 04:35:43PM +0100, Jiri Olsa wrote:
> +a) Build makefiles
> +------------------
> +User supplies 'Build' makefiles that contains objects summary,
> +like for example following 'krava/Build' file:
> +
> +  perf-y += a.o
> +  perf-y += b.o
> +
> +The build framework is triggered by:
> +  $ make -f Makefile.build dir=krava obj=perf
> +
> +which produces 'krava/perf-in.o' object file that has both
> +a.o and b.o objects compiled in linked together.
> +
> +The 'Build' makefile can contains multiple objects definitions
> +to allow building separated binaries, like:
> +
> +  perf-y += a.o
> +  perf-y += b.o
> +
> +  libperf-y += c.o
> +  libperf-y += d.o
> +
> +If the build framework is triggered by:
> +  $ make -f Makefile.build dir=krava obj=libperf
> +
> +it produces 'krava/libperf-in.o' object file that has both
> +a.o and b.o objects compiled in linked together.

Ok, question: you say those "Build" files are supplied by the user. Does
that mean that everyone has to go and write their own or are we still
using Kconfig and doing it in a more user-friendly manner?

I've probably missed this in the whole perf fastlane development... :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
