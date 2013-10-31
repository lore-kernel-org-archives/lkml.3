Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3JaXcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:32:00 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51677 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3JaXb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:31:58 -0400
Message-ID: <5272E86B.7090003@gmail.com>
Date: Thu, 31 Oct 2013 17:31:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: perf version not set when building out of tree
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building out of tree:

make perf-tar-src-pkg
tar -xf perf-<ver>.tar -C /tmp
cd /tmp/perf<ver>
make -C tools/perf

you get the warning message:
make[1]: *** No rule to make target `kernelversion'.  Stop.

which comes from tools/perf/util/PERF-VERSION-GEN,

if test -z "$TAG"
then
     TAG=$(MAKEFLAGS= make -sC ../.. kernelversion)
fi

There is no top level Makefile. perf is actually built, but has no 
version info:

$ tools/perf/perf --version
perf version

I thought someone had proposed a way to fix that.

David
