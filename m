Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaAOB7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:59:02 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46843 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOB7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:59:01 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-c1-52d5eb63e8e7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf probe: Build error with missing libraries
References: <20140113180400.GD5318@ghostprotocols.net>
	<20140113181458.GE5318@ghostprotocols.net>
	<52D495D1.5080505@hitachi.com>
	<20140114130907.GA29798@ghostprotocols.net>
Date: Wed, 15 Jan 2014 10:58:58 +0900
In-Reply-To: <20140114130907.GA29798@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 14 Jan 2014 10:09:07 -0300")
Message-ID: <87sisq9fa5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, 14 Jan 2014 10:09:07 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 14, 2014 at 10:41:37AM +0900, Masami Hiramatsu escreveu:
>> (2014/01/14 3:14), Arnaldo Carvalho de Melo wrote:
>> > Jiri, this is something else for the give-me-more-ponies list for
>> > tests/make: build it on freshly provisioned systems with multiple mixes
>> > of devel packages installed ;-)
>  
>> I think we can change makefile to get some combinations of config options
>> when building perf tools.
>
> This is what:
>
>  make -C tools/perf -f tests/make
>
> does, and we use it already, many config combos are tested, but that
> kinda expects that all optional devel libs be installed.

I've been thinking that the above should look like below.

  make build-test (-C tools/perf)


Maybe something like this?


diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index eefb9fb0c02f..e110c2a2ade1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -75,6 +75,12 @@ clean:
 	$(make)
 
 #
+# The build-test target is not really parallel, don't print the jobs info:
+#
+build-test:
+	@$(MAKE) -f tests/make --no-print-directory
+
+#
 # All other targets get passed through:
 #
 %:

-- 
Thanks,
Namhyung
