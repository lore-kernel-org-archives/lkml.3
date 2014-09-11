Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaIKVgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:36:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:39576 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaIKVgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:36:42 -0400
Date: Thu, 11 Sep 2014 18:36:38 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf pollfd v3
Message-ID: <20140911213638.GC1801@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <20140911113336.GB13634@krava.brq.redhat.com>
 <20140911114825.GC13634@krava.brq.redhat.com>
 <20140911133029.GC10158@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911133029.GC10158@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 11, 2014 at 10:30:29AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Sep 11, 2014 at 01:48:25PM +0200, Jiri Olsa escreveu:
> > so the reason was that my fd lib stuff did not get rebuilt..
> 
> Thanks a lot! I missed that one, will fold it into the patch that
> introduces fdarray and add a v2: comment attributing credit to you, so
> that bisection works.
 
> > you probably want to add attached change, before there's the
> > fix for the apik library

Done, need just to move that fcntl O_NONBLOCK from fdarray__add() to
perf_evlist__add_pollfd(), what I have now is at:

https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=perf/fdarray.v3

In case you want to see if itaddresses your concerns.

The last cset should address what you pointed out about unmapping only
when the events gets completely drained from the ring buffer.

I'll do the fcntl() fix, test your drain-last-events scenario and
repost.

- Arnaldo


