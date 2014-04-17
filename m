Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaDQSxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:53:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaDQSx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:53:26 -0400
Date: Thu, 17 Apr 2014 20:52:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/3] perf top/tui: Fixes for percentage filter behavior
Message-ID: <20140417185258.GJ7422@krava.brq.redhat.com>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
 <20140417120046.GC7422@krava.brq.redhat.com>
 <1397741900.1731.17.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397741900.1731.17.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 10:38:19PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> 2014-04-17 (목), 14:00 +0200, Jiri Olsa:
> > On Thu, Apr 17, 2014 at 04:53:23PM +0900, Namhyung Kim wrote:
> > > Hi,
> > > 
> > > This is a small fixes for a bug in perf top I found during some tests.
> > > It gets segfault if symbol filter found no entries - accessing NULL
> > > pointer in that case.
> > 
> > yep, I hit that yesterday as well, but I ended up just with
> > the patch below, your changes seems more comprehensive ;-)
> > going to review..
> 
> Well, the end result will be same, but I think it should have 0
> nr_entries when there's no entry to show.

also I hit another issue ;-)

- running report on data with callchains, and the screen is populated to the middle
- press 'END' key and the cursor goes to the bottom of the screen (I can tell based
  on the scrollbar), but there are no entries

I could make the cursor appear by pressing UP arrow, I bisected to:
  f214833 perf report: Add --percentage option

not sure where's the problem

thanks,
jirka
