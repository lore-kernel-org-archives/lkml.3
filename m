Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3GHOey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:34:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:11992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab3GHOex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:34:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1020,1363158000"; 
   d="scan'208";a="265436179"
Message-ID: <51DACE08.5030109@intel.com>
Date: Mon, 08 Jul 2013 07:34:48 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        dave.hansen@linux.intel.com, ak@linux.intel.com, jolsa@redhat.com
Subject: Re: [PATCH] perf: fix interrupt handler timing harness
References: <20130704223010.GA30625@quad>
In-Reply-To: <20130704223010.GA30625@quad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 03:30 PM, Stephane Eranian wrote:
> There was an misunderstanding on the API of the do_div()
> macro. It returns the remainder of the division and this
> was not what the function expected leading to disabling the
> interrupt latency watchdog.

"Misunderstanding" is a very kind term for what I did there.  Stephane,
were you actually running in to the new cpu limit, or were you just
trying to update kernel.perf_event_max_sample_rate?

BTW, I also did the same thing in 2ab00456:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2ab00456ea8a0d79acb1390659b98416111880b2

I'll have a patch out shortly for that one, but its damage would be
limited to a bogus printk.
