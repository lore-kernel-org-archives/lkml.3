Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbbABRgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:36:19 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41684 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbABRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:36:18 -0500
Date: Fri, 2 Jan 2015 18:36:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <florian@openwrt.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Mark Salter <msalter@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC/PATCHSET 00/30] perf tools: New build framework
Message-ID: <20150102173612.GA5941@gmail.com>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@kernel.org> wrote:

> [...] The basic idea is the same as in kbuild system, with some 
> minor changes to allow for multiple binaries build definitions.

>  tools/perf/Build                                |  48 ++
>  tools/perf/Build.include                        |  75 ++++
>  tools/perf/Documentation/Build                  | 123 +++++
>  tools/perf/Makefile.build                       | 122 +++++
>  tools/perf/Makefile.perf                        | 566 +++---------------------

>  47 files changed, 827 insertions(+), 541 deletions(-)

Even the diffstat looks pretty good: only a modest line count 
increase.

It would be useful to put this (and other build features - such 
as features/parallelisation support) into tools/kbuild/ though, 
so that other tooling can make easy use of it as well. For 
example tools/kvm/ (an external project) started off with an 
earlier version of the perf build system.

Sharing that would make quite a bit of sense, as tooling (and 
most user-space project) build systems are usually have pretty 
poor quality.

Thanks,

	Ingo
