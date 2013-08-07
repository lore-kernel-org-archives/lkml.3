Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab3HGUJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:09:26 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:37616 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab3HGUJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:09:25 -0400
Date: Wed, 7 Aug 2013 17:09:18 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH/RFC 0/4] perf ui/gtk: Separate out GTK code to a shared
 object (v2)
Message-ID: <20130807200918.GF2665@ghostprotocols.net>
References: <1375766056-19377-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375766056-19377-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 06, 2013 at 02:14:12PM +0900, Namhyung Kim escreveu:
> Hi,
> 
> This is v2 of gtk code separation patchset to reduce library
> dependencies of the perf executable.
> 
> I only built libperf-gtk.so with -fPIC, and it's not linked to libperf
> at build time.  All unresolved symbols used for perf should be
> resolved at runtime via perf executable (so libperf.a) - I didn't know
> that the linker permits unresolved symbols in a shared library at
> build time.
> 
> Tested on my x86-64 machine only.  It seems work well for me.

Not for me, please take a look at O= handling:

[acme@sandy linux]$ make -j8 O=/tmp/build/perf -C tools/perf/ install
<SNIP>
    CHK gtk2
    CHK -DHAVE_GTK_INFO_BAR
<SNIP>
make: Entering directory `/home/acme/git/linux/tools/perf'
make: *** No rule to make target `/tmp/build/perf/ui/gtk/browser.c',
needed by `/tmp/build/perf/ui/gtk/browser.o'.  Stop.
make: *** Waiting for unfinished jobs....
make[1]: Entering directory `/home/acme/git/linux/tools/lib/traceevent'
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent
make rule.
make[1]: Entering directory `/home/acme/git/linux/tools/lib/lk'
    AR liblk.a
make[1]: Leaving directory `/home/acme/git/linux/tools/lib/traceevent'
make[1]: Leaving directory `/home/acme/git/linux/tools/lib/lk'
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@sandy linux]$ 
 
> The patch 1 is a bug fix and can be applied independently.

I took it, thanks.
