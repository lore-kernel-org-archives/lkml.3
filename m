Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3GHUyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:54:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:9987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab3GHUyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:54:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1022,1363158000"; 
   d="scan'208";a="366719304"
Date: Mon, 8 Jul 2013 13:54:01 -0700
From: Andi Kleen <ak@linux.jf.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: Stephane Eranian <eranian@google.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        dave.hansen@linux.jf.intel.com, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: fix interrupt handler timing harness
Message-ID: <20130708205401.GG5643@tassilo.jf.intel.com>
References: <20130704223010.GA30625@quad>
 <51DACE08.5030109@intel.com>
 <CABPqkBT3QcKPGUoo2Wuvn0TdK3TKcMWtbuq4jGqbouBvqaKgDg@mail.gmail.com>
 <51DB1B75.8060303@intel.com>
 <CABPqkBRdK5WwokEWE3tQZiAyO3pWbS9aUn7HUkQT+XsMYfJUiA@mail.gmail.com>
 <51DB2271.1010009@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DB2271.1010009@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I did a quite a bit of ftracing to look for spots inside the handler
> which were taking large amounts of time.  There were none.  The
> execution time was spread very evenly over the entire nmi handler.  It
> didn't appear to be any individual hot cachelines or doing something
> silly like sitting in a loop handling lots of PMU events.

In some cases callgraphs seemed to be quite expensive (large fraction
of the handler time)

-Andi
