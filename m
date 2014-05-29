Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaE2HEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:04:31 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62947 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbaE2HEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:04:30 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix 'make help' message error
References: <1400993449-24094-1-git-send-email-nasa4836@gmail.com>
Date: Thu, 29 May 2014 16:04:24 +0900
In-Reply-To: <1400993449-24094-1-git-send-email-nasa4836@gmail.com> (Jianyu
	Zhan's message of "Sun, 25 May 2014 12:50:49 +0800")
Message-ID: <87sintf4lj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianyu,

On Sun, 25 May 2014 12:50:49 +0800, Jianyu Zhan wrote:
> Currently 'make help' message has such hint:
>
>    use "make prefix=<path> <install target>" to install to a particular
>        path like make prefix=/usr/local install install-doc
>
> But this is misleading, when I specify "prefix=/usr/local", it has got no
> respect at all. Instead, what takes effect is the "DESTDIR" variable.
> In this case, "DESTDIR" has a empty value, so the actual install
> directory falls back $HOME, not '/usr/local'.
>
> Specifying "DESTDIR=/usr/local" will work as desired.
>
> This patch fixes the help message.

I don't know what's the correct way to do this.  But it seems like the
prefix was overwritten when given from user, so below patch will work
also.

Thanks,
Namhyung


diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 729bbdf5cec7..80a8a0a1c7e7 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -599,7 +599,7 @@ endif
 
 # Make the path relative to DESTDIR, not to prefix
 ifndef DESTDIR
-prefix = $(HOME)
+prefix ?= $(HOME)
 endif
 bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
