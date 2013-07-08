Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab3GHU4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:56:40 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33839 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab3GHU4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:56:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130708205401.GG5643@tassilo.jf.intel.com>
References: <20130704223010.GA30625@quad>
	<51DACE08.5030109@intel.com>
	<CABPqkBT3QcKPGUoo2Wuvn0TdK3TKcMWtbuq4jGqbouBvqaKgDg@mail.gmail.com>
	<51DB1B75.8060303@intel.com>
	<CABPqkBRdK5WwokEWE3tQZiAyO3pWbS9aUn7HUkQT+XsMYfJUiA@mail.gmail.com>
	<51DB2271.1010009@sr71.net>
	<20130708205401.GG5643@tassilo.jf.intel.com>
Date: Mon, 8 Jul 2013 22:56:38 +0200
Message-ID: <CABPqkBQEWZ05_mKLDZ1r+_VO6QzD=cWAb=xFXGEpmOMXG7mgOw@mail.gmail.com>
Subject: Re: [PATCH] perf: fix interrupt handler timing harness
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.jf.intel.com>
Cc: Dave Hansen <dave@sr71.net>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        dave.hansen@linux.jf.intel.com, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 10:54 PM, Andi Kleen <ak@linux.jf.intel.com> wrote:
>> I did a quite a bit of ftracing to look for spots inside the handler
>> which were taking large amounts of time.  There were none.  The
>> execution time was spread very evenly over the entire nmi handler.  It
>> didn't appear to be any individual hot cachelines or doing something
>> silly like sitting in a loop handling lots of PMU events.
>
> In some cases callgraphs seemed to be quite expensive (large fraction
> of the handler time)
>
In my case, I am not doing callgraphs, just regular cycles.
