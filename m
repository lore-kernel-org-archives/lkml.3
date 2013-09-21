Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab3IUMro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 08:47:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3IUMrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 08:47:43 -0400
Date: Sat, 21 Sep 2013 14:47:14 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] perf tools: Use per-file CFLAGS in Makefile
Message-ID: <20130921124714.GA8304@krava.brq.redhat.com>
References: <1379297476-20793-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379297476-20793-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 11:11:16AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Some files need additional compiler flags to be built successfully.
> Cleanup Makefile by using optional per-file CFLAGS which look like
> CFLAGS_dir_filename.o

I like it, but I'm getting following error:

  $ make 
      ...
      AR libperf.a
  ar: util/rbtree.o: No such file or directory
  make: *** [libperf.a] Error 1
  $

probably because rbtree object is based in kernel lib


Also this patch collides with your previous:
  perf tools: Separate out GTK codes to libperf-gtk.so

which I needed to revert first to get this one applied.

jirka
