Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3JOCJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 22:09:45 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:50286 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3JOCJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 22:09:44 -0400
Date: Mon, 14 Oct 2013 23:09:35 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: perf top using /proc/kcore
Message-ID: <20131015020935.GB30662@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

	While testing 'perf top -U' to reply a message in another thread
I noticed that ksm symbols appeared as '[kernel]', and only when I tried
'perf top -U -v' to look at the DSO long name I noticed that it was...
/proc/kcore.

	Question is: since we have access to /proc/modules, can't we
parse that, as when we have access to vmlinux, and recreate the mmaps,
etc, and see:

	[module]  symbol

	Instead of grouping everything into a single [kernel] bucket?

- Arnaldo
