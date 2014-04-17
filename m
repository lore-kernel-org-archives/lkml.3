Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaDQNwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:52:44 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:46385 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaDQNwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:52:40 -0400
Subject: Re: [PATCH 3/3] perf top/tui: Update nr_entries properly after
 filter is applied
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20140417131220.GB19339@krava.brq.redhat.com>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
	 <1397721206-15393-4-git-send-email-namhyung@kernel.org>
	 <20140417131220.GB19339@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Apr 2014 22:52:32 +0900
Message-ID: <1397742752.1731.30.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-17 (목), 15:12 +0200, Jiri Olsa:
> On Thu, Apr 17, 2014 at 04:53:26PM +0900, Namhyung Kim wrote:
> > The hist_browser__reset() is only called right after a filter is
> > applied so it needs to update browser->nr_entries properly.  We cannot
> > use hists->nr_non_filtered_entries directly since it's possible that
> > such entries are also filtered out by minimum percentage.
> > 
> > In addition when a filter is used for perf top, hist browser's
> > nr_entries field was not updated after applying the filter.  But it
> > needs to be updated as new samples are coming.
> > 
> > Rename ->nr_pcnt_entries and hist_browser__update_pcnt_entries() to
> > ->nr_filtered_entries and hist_browser__update_nr_entries() since it's
> > now used for filtered entries as well.
> 
> Could you please split out that rename into separate patch?

Will do (with browser__has_filter() change).

Thanks,
Namhyung


