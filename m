Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3CCUho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 15:37:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab3CCUhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 15:37:43 -0500
Date: Sun, 3 Mar 2013 17:36:43 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] perf, liblk: Fix _FORTIFY_SOURCE builds
Message-ID: <20130303203643.GA20695@infradead.org>
References: <1362338733-8718-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362338733-8718-1-git-send-email-bp@alien8.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 03, 2013 at 08:25:33PM +0100, Borislav Petkov escreveu:
> Jiri Olsa triggers the following build error:

>     SUBDIR ../lib/lk/
>     CC debugfs.o
> In file included from /usr/include/errno.h:29:0,
>                  from debugfs.c:1:
> /usr/include/features.h:314:4: error: #warning _FORTIFY_SOURCE requires compiling with optimization (-O) [-Werror=cpp]

> This is because enabling buffer overflow checks through _FORTIFY_SOURCE
> require compiler optimizations to be enabled too. However, those are
> not. Enable them by simply copying the perf optimization level. It can
> be expanded later if we want to support debug builds, etc.

Thanks, applied.

- Arnaldo
