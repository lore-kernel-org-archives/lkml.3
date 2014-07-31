Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaGaIfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:35:55 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36908 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaGaIfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:35:52 -0400
MIME-Version: 1.0
From: Namhyung Kim <namhyung@gmail.com>
Date: Thu, 31 Jul 2014 17:35:32 +0900
Message-ID: <CAM9d7ci1grg4NSMJahr-zjo+v8CkumbnwREhjkc+o6y9kYuaGw@mail.gmail.com>
Subject: perf tools: Question about kmem and kernel symbol resolution
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking kernel symbol mismatch issue, and found something in perf
kmem code.  The commit e727ca73f85d ("perf kmem: Resolve kernel
symbols again") added perf_session__create_kernel_maps() but I don't
know why.  Why did it miss the MMAP event?

I think if we create a kernel maps at report time, it might not match
to samples in a perf.data if it's recorded on a different kernel.
This is the main reason of the mismatch problem I'm currently chasing
IMHO.  What am I missing?

Thanks,
Namhyung
