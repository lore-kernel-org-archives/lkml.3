Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbaGHT2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:28:37 -0400
Received: from one.firstfloor.org ([193.170.194.197]:35700 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510AbaGHT2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:28:35 -0400
Date: Tue, 8 Jul 2014 21:28:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org
Subject: Re: perf: Add support for full Intel event lists v7
Message-ID: <20140708192833.GI18735@two.firstfloor.org>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <20140708184311.GA14707@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708184311.GA14707@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for testing.

On Tue, Jul 08, 2014 at 11:43:11AM -0700, Sukadev Bhattiprolu wrote:
> | The JSON format and perf parser has some minor Intelisms, but they
> | are simple and small and optional. It's easy to extend, so it would be
> | possible to use it for other CPUs too, add different pmu attributes, and
> | add new download sites to the downloader tool.
> 
> Is there a minimal set of JSON entries an architecture would need ?

That should be enough, assuming the EventCode is enough to select
the event.

> 
> I tried the following on Power
> 	[
> 	  {
> 	    "EventCode": "2",
> 	    "EventName": "PM_INST_CMPL",
> 	    "BriefDescription": "Instructions completed",
> 	    "PublicDescription": "Number of PPC instructions finished",
> 	  },
> 	  {
> 	    "EventCode": "0x1E",
> 	    "EventName": "PM_CYC",
> 	    "BriefDescription": "Cycles completed",
> 	    "PublicDescription": "Number of PPC cycles finished",
> 	  }
> 	]
> 
> 	/tmp/perf record --events-file=/tmp/power8.json -e PM_INST_CMPL sleep 1
> 
> works, but for some TBD reason,
> 
> 	/tmp/perf list --events-file=/tmp/power8.json doesn't list PM_INST_CMPL.

Works for me with your input file:

% perf list --events-file t.json
...
  pm_cyc                                             [Cycles completed]
  pm_inst_cmpl                                       [Instructions completed]


> Another observation was that the order of --events-file and -e is significant.
> Maybe worth a note in the man page.

Will add.

> Can you specify the qualifiers like ':k' or ':ku' with the events on
> Intel ?
>to only monitor kernel or user ? Or do they need some additional JSON
> entries ?

They can be all specified.


> With the above events file, I get "invalid event" for 'PM_INST_CMPL:u'

It works in new style syntax, like

perf stat --events-file t.json  -e cpu/pm_inst_cmpl/u  ls


Thanks,
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
