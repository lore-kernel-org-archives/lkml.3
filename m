Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbaDQNMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbaDQNMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:12:46 -0400
Date: Thu, 17 Apr 2014 15:12:20 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/3] perf top/tui: Update nr_entries properly after
 filter is applied
Message-ID: <20140417131220.GB19339@krava.brq.redhat.com>
References: <1397721206-15393-1-git-send-email-namhyung@kernel.org>
 <1397721206-15393-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397721206-15393-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 04:53:26PM +0900, Namhyung Kim wrote:
> The hist_browser__reset() is only called right after a filter is
> applied so it needs to update browser->nr_entries properly.  We cannot
> use hists->nr_non_filtered_entries directly since it's possible that
> such entries are also filtered out by minimum percentage.
> 
> In addition when a filter is used for perf top, hist browser's
> nr_entries field was not updated after applying the filter.  But it
> needs to be updated as new samples are coming.
> 
> Rename ->nr_pcnt_entries and hist_browser__update_pcnt_entries() to
> ->nr_filtered_entries and hist_browser__update_nr_entries() since it's
> now used for filtered entries as well.

Could you please split out that rename into separate patch?

thanks,
jirka
