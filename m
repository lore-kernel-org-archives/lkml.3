Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbaDIFbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 01:31:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48813 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaDIFbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 01:31:04 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@kernel.org, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 6/6] perf, sort:  Allow unique sorting instead of combining hist_entries
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
	<1395689676-214799-7-git-send-email-dzickus@redhat.com>
Date: Wed, 09 Apr 2014 14:31:00 +0900
In-Reply-To: <1395689676-214799-7-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:34:36 -0400")
Message-ID: <87ha63t6gb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 15:34:36 -0400, Don Zickus wrote:
> The cache contention tools needs to keep all the perf records unique in order
> to properly parse all the data.  Currently add_hist_entry() will combine
> the duplicate record and add the weight/period to the existing record.
>
> This throws away the unique data the cache contention tool needs (mainly
> the data source).  Create a flag to force the records to stay unique.

No.  This is why I said you need to add 'mem' and 'snoop' sort keys into
the c2c tool.  This is not how sort works IMHO - if you need to make
samples unique let the sort key(s) distinguish them somehow, or you can
combine same samples (in terms of sort kes) and use the combined entry's
stat.nr_events and stat.period or weight.

Thanks,
Namhyung
