Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaBKMJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:09:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52169 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaBKMJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:09:31 -0500
Date: Tue, 11 Feb 2014 13:09:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>, Don Zickus <dzickus@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Richard Fowles <fowles@inreach.com>
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140211120921.GX9987@twins.programming.kicks-ass.net>
References: <CABPqkBRzvfcdKGG4yY9q1PmtVL5Z=9H1RzHg8QDMN42a7=AF6A@mail.gmail.com>
 <20140211071401.GG27965@twins.programming.kicks-ass.net>
 <CABPqkBRn+AVUA-KTx-JQ28j1NhE4pDQe5vjb5NKGx0jrZq8g_Q@mail.gmail.com>
 <20140211105217.GS9987@twins.programming.kicks-ass.net>
 <CABPqkBROriDQa5-b-w45zV+2gS94oEW1c_bYwGmYAeYcqPoUog@mail.gmail.com>
 <20140211110242.GU9987@twins.programming.kicks-ass.net>
 <CABPqkBQhUCUOszQzBJZd_pwX-nLf6y=0X-+swPi0pE3ivRpVcg@mail.gmail.com>
 <CABPqkBSbBqOtvstKwQWD7jM8nn3XEdq0OXMjW8Z8oCF17uRYPw@mail.gmail.com>
 <20140211111421.GN27965@twins.programming.kicks-ass.net>
 <20140211115013.GE28757@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211115013.GE28757@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 08:50:13AM -0300, Arnaldo Carvalho de Melo wrote:
> 3) PERF_SAMPLE_REGS_USER (from a quick look, why do we have "USER" in
> it? Jiri?)

Note that the regs are in the POST instruction state, so any op that
does something like:

  MOV %edx, $(eax+edx*8)

Will have lost the original index value.
