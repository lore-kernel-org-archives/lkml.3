Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaEGTBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:01:19 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:57917 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaEGTBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:01:17 -0400
Date: Wed, 7 May 2014 21:01:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 2/3] perf tools: Cache dso data file descriptor
Message-ID: <20140507190111.GA21160@gmail.com>
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
 <1397756352-26694-3-git-send-email-jolsa@redhat.com>
 <1398609395.1689.17.camel@leonhard>
 <20140428100133.GE1109@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140428100133.GE1109@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Sun, Apr 27, 2014 at 11:36:35PM +0900, Namhyung Kim wrote:
> > 2014-04-17 (목), 19:39 +0200, Jiri Olsa:
> > > Keeping the data file description open for the whole life
> > > of the dso object.
> > 
> > I suspect there might be an issue for reporting very large data file
> > with this approach - like open file limit?
> 
> I've got as high as ~200 openned file descriptors for
> ~2GB data of system wide monitoring

Note that 200 open file descriptors in themselves are not a 
scalability problem on Linux, as long as perf doesn't walk them 
linearly anywhere.

I think we are reasonably fast even with a million open files in a 
singe process, or so.

Thanks,

	Ingo
