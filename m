Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbaIINDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:03:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:19252 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaIINDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:03:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="476328156"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 09/22] perf: Support overwrite mode for AUX area
In-Reply-To: <20140909124345.GN16043@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com> <1408538179-792-10-git-send-email-alexander.shishkin@linux.intel.com> <20140909084436.GY19379@twins.programming.kicks-ass.net> <87y4ttt9m0.fsf@ashishki-desk.ger.corp.intel.com> <20140909105537.GJ6758@twins.programming.kicks-ass.net> <87sik1t3g9.fsf@ashishki-desk.ger.corp.intel.com> <20140909124345.GN16043@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 09 Sep 2014 16:00:43 +0300
Message-ID: <87ppf5t0ck.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Sep 09, 2014 at 02:53:42PM +0300, Alexander Shishkin wrote:
>
>> We can infer where the new data starts from the timestamps in the trace
>> stream, so the decoder can take care of it (and that's how it's done at
>> the moment).
>
> So that means the data stream can be read from arbitrary locations,
> right? I can imagine not all data streams are always readable like that
> (for instance the perf datastream is not).
>
> Does it make sense to have the driver provide head,tail for this mode?
> In your case you can simply provide whatever, but for those where it
> matters they can ensure consistent data such that the stream might be
> recoverable.

Yes, there's no reason not to, and some HW might indeed benefit from
this.

Regards,
--
Alex
