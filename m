Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbaCSKYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:24:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259AbaCSKYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:24:38 -0400
Date: Wed, 19 Mar 2014 11:19:08 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 06/13] perf tools: Use tid in mmap/mmap2 events to find
 maps
Message-ID: <20140319101907.GE1449@krava.brq.redhat.com>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
 <1395177965-8879-7-git-send-email-acme@infradead.org>
 <532943A2.7040407@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532943A2.7040407@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 09:13:38AM +0200, Adrian Hunter wrote:
> On 18.03.2014 23:25, Arnaldo Carvalho de Melo wrote:
> > From: Don Zickus <dzickus@redhat.com>
> > 
> > Now that we can properly synthesize threads system-wide, make sure the
> > mmap and mmap2 events use tids instead of pids to locate their maps.
> 
> This is a good change but it cannot go yet because it is dependent on Jiri's
> "perf tools: Share map groups within process" series.
> 
> perf tools assume that threads share virtual memory.  That means that a
> mapping created by one thread is visible to all threads in the thread group.
>  That was implemented by putting all the maps on the thread group leader
> (pid == tid).  The alternative is to share the map groups instead, which is
> what Jiri is doing.

right, this needs the sharing map groups changes
(or the 1/2 patch Don sent prior to this patch)

jirka
