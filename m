Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaDJFJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 01:09:16 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:50933 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaDJFJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 01:09:14 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@kernel.org, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 6/6] perf, sort:  Allow unique sorting instead of combining hist_entries
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
	<1395689676-214799-7-git-send-email-dzickus@redhat.com>
	<87ha63t6gb.fsf@sejong.aot.lge.com> <20140409135706.GD8488@redhat.com>
Date: Thu, 10 Apr 2014 14:09:11 +0900
In-Reply-To: <20140409135706.GD8488@redhat.com> (Don Zickus's message of "Wed,
	9 Apr 2014 09:57:06 -0400")
Message-ID: <87d2gpu5xk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Wed, 9 Apr 2014 09:57:06 -0400, Don Zickus wrote:
> On Wed, Apr 09, 2014 at 02:31:00PM +0900, Namhyung Kim wrote:
>> On Mon, 24 Mar 2014 15:34:36 -0400, Don Zickus wrote:
>> > The cache contention tools needs to keep all the perf records unique in order
>> > to properly parse all the data.  Currently add_hist_entry() will combine
>> > the duplicate record and add the weight/period to the existing record.
>> >
>> > This throws away the unique data the cache contention tool needs (mainly
>> > the data source).  Create a flag to force the records to stay unique.
>> 
>> No.  This is why I said you need to add 'mem' and 'snoop' sort keys into
>> the c2c tool.  This is not how sort works IMHO - if you need to make
>> samples unique let the sort key(s) distinguish them somehow, or you can
>> combine same samples (in terms of sort kes) and use the combined entry's
>> stat.nr_events and stat.period or weight.
>
> Ok.  I understand your point.  Perhaps this was my lack of fully
> understanding the sorting algorithm when I did this.  I can look into
> adding the 'mem' and 'snoop'.
>
> One concern I do have is we were caculating statistics based on the weight
> (mean, median, stddev).  I was afraid that combining the entries would
> throw off our calculations as we could no longer accurately determine them
> any more.  Is that true?

Yes, if you want to calculate the stats accurately, it needs to be done
when processing samples not hist_entries IMHO.

Thanks,
Namhyung
