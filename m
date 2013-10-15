Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab3JOGOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:14:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:47539 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab3JOGOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:14:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,497,1378882800"; 
   d="scan'208";a="374816377"
Message-ID: <525CDD11.40803@intel.com>
Date: Tue, 15 Oct 2013 09:13:37 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf top using /proc/kcore
References: <20131015020935.GB30662@ghostprotocols.net>
In-Reply-To: <20131015020935.GB30662@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/13 05:09, Arnaldo Carvalho de Melo wrote:
> Hi Adrian,
> 
> 	While testing 'perf top -U' to reply a message in another thread
> I noticed that ksm symbols appeared as '[kernel]', and only when I tried
> 'perf top -U -v' to look at the DSO long name I noticed that it was...
> /proc/kcore.
> 
> 	Question is: since we have access to /proc/modules, can't we
> parse that, as when we have access to vmlinux, and recreate the mmaps,
> etc, and see:
> 
> 	[module]  symbol
> 
> 	Instead of grouping everything into a single [kernel] bucket?

I would suggest just splitting the maps and giving them names, rather than
splitting the dso as well.  That would mean changing places that have:

	map->dso->short_name

to

	map->name ? map->name : map->dso->short_name


