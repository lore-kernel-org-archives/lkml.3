Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaDWNOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:14:42 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:59821 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaDWNOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:14:39 -0400
Date: Wed, 23 Apr 2014 15:14:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20140423131433.GB23224@gmail.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Just reporting two bugs I found today - unrelated to your the 
perf/urgent pull request.)

1)

Even when the most modern unwind library is found, the autodetection 
is spammy:


 Auto-detecting system features:
 ...                         dwarf: [ on  ]
 ...                         glibc: [ on  ]
 ...                          gtk2: [ on  ]
 ...                      libaudit: [ on  ]
 ...                        libbfd: [ on  ]
 ...                        libelf: [ on  ]
 ...                       libnuma: [ on  ]
 ...                       libperl: [ on  ]
 ...                     libpython: [ on  ]
 ...                      libslang: [ on  ]
 ...                     libunwind: [ on  ]
 ...            libdw-dwarf-unwind: [ on  ]
 ...     DWARF post unwind library: libunwind

The 'DWARF post unwind library' line is somewhat superfluous. I 
realize that it prints out the library selected - but that's obvious 
from the 'libdw-dwarf-unwind' line above it already, right?

Furthermore, it breaks the autodetection output format.

2)

On latest Ubuntu (14.04) the tip:master build fails with:

 /usr/bin/ld: cannot find -liberty
 collect2: error: ld returned 1 exit status

The autodetection sequence reports all green entries, so something's 
funky going on there.

Thanks,

	Ingo
