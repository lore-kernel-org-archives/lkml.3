Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3KKT61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:58:27 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36361 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3KKT6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:58:19 -0500
Date: Mon, 11 Nov 2013 16:58:10 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: "Test object code reading" failing, debug messages don't help
Message-ID: <20131111195810.GK27198@ghostprotocols.net>
References: <20131111195117.GI27198@ghostprotocols.net>
 <20131111195559.GJ27198@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111195559.GJ27198@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 11, 2013 at 04:55:59PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Nov 11, 2013 at 04:51:17PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Hi Adrian,
> > 
> > 	I have perf test failing here:
> > 
> > [root@ssdandy ~]# perf test 21
> > 21: Test object code reading                               : FAILED!
> > [root@ssdandy ~]# 
> > 
> > Try it with -v, but all messages, except for that elf header, which I
> > assume is for a previous entry that is not suitable and should not be
> > considered, seems to say all is well, except that the test fails :-\
> 
> If I try gdb on test__code_reading, go on stepping thru it to try to
> figure out why it fails, it works :-\

Why this is so is still unclear, but since the other problem I had was
due to the kernel reducing the max sample_freq, I tried:

[root@ssdandy ~]# echo 10000 > /proc/sys/kernel/perf_event_max_sample_rate 
[root@ssdandy ~]# perf test 21
21: Test object code reading                               : Ok
[root@ssdandy ~]# echo 7000 > /proc/sys/kernel/perf_event_max_sample_rate 
[root@ssdandy ~]# perf test 21
21: Test object code reading                               : FAILED!
[root@ssdandy ~]# 

Checking where in this test the sample_freq is set...

- Arnaldo
