Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaAMSGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:06:07 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:64588 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaAMSGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:06:04 -0500
Date: Mon, 13 Jan 2014 15:04:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: perf probe: Build error with missing libraries
Message-ID: <20140113180400.GD5318@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a Ubuntu system just installed (13.10, x86_64), I'm installing the
devel libs one by one to check if there are problems with the automatic
disabling of features that requires libraries not installed.

Stumbled at this:

  CC       /tmp/build/perf/util/probe-event.o
util/probe-event.c: In function ‘try_to_find_probe_trace_events’:
util/probe-event.c:753:46: error: unused parameter ‘target’
[-Werror=unused-parameter]
     int max_tevs __maybe_unused, const char *target)
                                              ^
util/probe-event.c: At top level:
util/probe-event.c:193:12: error: ‘get_text_start_address’ defined but
not used [-Werror=unused-function]
 static int get_text_start_address(const char *exec, unsigned long
*address)
            ^
cc1: all warnings being treated as errors
make[1]: *** [/tmp/build/perf/util/probe-event.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [install] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'
acme@ubuntu13:~/git/linux$ 

Investigating...

- Arnaldo
