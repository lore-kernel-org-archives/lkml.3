Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaBKLO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:14:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50825 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaBKLO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:14:27 -0500
Date: Tue, 11 Feb 2014 12:14:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Richard Fowles <fowles@inreach.com>
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140211111421.GN27965@twins.programming.kicks-ass.net>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <20140210212955.GC5002@laptop.programming.kicks-ass.net>
 <CABPqkBRzvfcdKGG4yY9q1PmtVL5Z=9H1RzHg8QDMN42a7=AF6A@mail.gmail.com>
 <20140211071401.GG27965@twins.programming.kicks-ass.net>
 <CABPqkBRn+AVUA-KTx-JQ28j1NhE4pDQe5vjb5NKGx0jrZq8g_Q@mail.gmail.com>
 <20140211105217.GS9987@twins.programming.kicks-ass.net>
 <CABPqkBROriDQa5-b-w45zV+2gS94oEW1c_bYwGmYAeYcqPoUog@mail.gmail.com>
 <20140211110242.GU9987@twins.programming.kicks-ass.net>
 <CABPqkBQhUCUOszQzBJZd_pwX-nLf6y=0X-+swPi0pE3ivRpVcg@mail.gmail.com>
 <CABPqkBSbBqOtvstKwQWD7jM8nn3XEdq0OXMjW8Z8oCF17uRYPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSbBqOtvstKwQWD7jM8nn3XEdq0OXMjW8Z8oCF17uRYPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 12:08:56PM +0100, Stephane Eranian wrote:
> Assuming you can decode and get the info about the base registers used,
> you'd have to do this for each arch with load/store sampling capabilities.
> this is painful compared to getting the portable info from dwarf directly.

But its useful now, as compared to whenever GCC gets around to
implementing more dwarves and that GCC getting used widely enough to
actually rely on it.

All you need for the decode is a disassembler, and every arch should
already have multiple of those. Should be easy to reuse one, right?
