Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3JTUnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 16:43:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab3JTUnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 16:43:11 -0400
Date: Sun, 20 Oct 2013 22:42:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/19] perf tools: Fix 32-bit cross build
Message-ID: <20131020204251.GA12044@krava>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
 <1382099356-4918-10-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382099356-4918-10-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 03:29:06PM +0300, Adrian Hunter wrote:
> Setting EXTRA_CFLAGS=-m32 did not work because CFLAGS
> was not passed around.

this breaks feature detection for me on x86_64,
I've got following errors misdetection with this patch:

...                       libperl: [ OFF ]
...                       on-exit: [ OFF ]

and the build fails as well:

  CC       builtin-stat.o
builtin-record.c:42:12: error: static declaration of ‘on_exit’ follows non-static declaration
In file included from util/util.h:51:0,
                 from builtin.h:4,
                 from builtin-record.c:8:
/usr/include/stdlib.h:536:12: note: previous declaration of ‘on_exit’ was here
make[1]: *** [builtin-record.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [all] Error 2


jirka
