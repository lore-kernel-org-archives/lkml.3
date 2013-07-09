Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3GIN1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:27:38 -0400
Received: from mail-ye0-f169.google.com ([209.85.213.169]:64498 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3GIN1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:27:37 -0400
Date: Tue, 9 Jul 2013 10:19:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Al Cooper <alcooperx@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@infradead.org,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Build failure when python-devel not installed
Message-ID: <20130709131926.GA3260@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	While trying to build perf on a freshly installed Fedora 18
machine I couldn't do it if python-devel isn't installed.

	The expected behaviour is for a warning to be emitted and the
build to continue.

	I bisected it down to:

commit 31160d7feab786c991780d7f0ce2755a469e0e5e
"perf tools: Fix GNU make v3.80 compatibility issue"
    
	If I revert this changeset, everything works as expected, I get:

config/Makefile:319: The path '/usr/bin/python-config' is not executable.
config/Makefile:323: No python-config tool was found
config/Makefile:323: Python support will not be built

and I get a perf binary with no python support.

	When python-devel is not installed and I have the above cset, I
get:

    CHK gtk2
    CHK -DHAVE_GTK_INFO_BAR
    CHK perl
config/Makefile:319: The path '/usr/bin/python-config' is not executable.
config/Makefile:319: *** Please set 'PYTHON_CONFIG' appropriately.  Stop.
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@sandy linux]$ 

	Can you take a look at this?

	Jiri, this brings another situation to be tested on the 'cd
tools/perf ; make -f tools/make' suite: removing/installing packages
needed to build with some feature to check that it just warns the user
that such feature won't be included instead of stopping the build :-)

- Arnaldo
