Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbbAUVcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:32:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbbAUVcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:32:46 -0500
Date: Wed, 21 Jan 2015 22:31:57 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 20/36] perf build: Add arch x86 objects building
Message-ID: <20150121213157.GH6835@krava.brq.redhat.com>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
 <1421771973-6022-21-git-send-email-jolsa@kernel.org>
 <54C0177C.3060703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C0177C.3060703@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 02:17:48PM -0700, David Ahern wrote:
> On 1/20/15 9:39 AM, Jiri Olsa wrote:
> >---
> >  tools/perf/arch/Build           |  1 +
> >  tools/perf/arch/arm/Build       |  0
> >  tools/perf/arch/arm64/Build     |  0
> >  tools/perf/arch/powerpc/Build   |  0
> >  tools/perf/arch/s390/Build      |  0
> >  tools/perf/arch/sh/Build        |  0
> >  tools/perf/arch/sparc/Build     |  0
> >  tools/perf/arch/x86/Build       |  2 ++
> >  tools/perf/arch/x86/Makefile    | 15 ---------------
> >  tools/perf/arch/x86/tests/Build |  2 ++
> >  tools/perf/arch/x86/util/Build  |  8 ++++++++
> >  11 files changed, 13 insertions(+), 15 deletions(-)
> >  create mode 100644 tools/perf/arch/arm/Build
> >  create mode 100644 tools/perf/arch/arm64/Build
> >  create mode 100644 tools/perf/arch/powerpc/Build
> >  create mode 100644 tools/perf/arch/s390/Build
> >  create mode 100644 tools/perf/arch/sh/Build
> >  create mode 100644 tools/perf/arch/sparc/Build
> >  create mode 100644 tools/perf/arch/x86/Build
> >  create mode 100644 tools/perf/arch/x86/tests/Build
> >  create mode 100644 tools/perf/arch/x86/util/Build
> 
> Since this is an x86 patch only the x86 Build files should be added here
> with the others added in respective arch patches.

the thing is that in arch/Build we now do:

+libperf-y += $(ARCH)/

which would make the build to fail on other architectures,
because the build framework requires 'Build' file in
nested directories.. and this patch adds it only for x86

jirka
