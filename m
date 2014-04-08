Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbaDHP11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:27:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:41171 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756811AbaDHP1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:27:24 -0400
Date: Tue, 8 Apr 2014 11:27:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Subject: Re: [RFC PATCH] time: Fix truncation in jiffies_to_usecs()
Message-ID: <20140408112722.360e8d03@gandalf.local.home>
In-Reply-To: <CA+8MBb+E_zT47qu4a6pqQWArrhs0gv1W=JKoy252_-Uw6HfbkA@mail.gmail.com>
References: <0214020@agluck-desk.sc.intel.com>
	<CA+8MBb+E_zT47qu4a6pqQWArrhs0gv1W=JKoy252_-Uw6HfbkA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2014 22:34:51 -0700
Tony Luck <tony.luck@gmail.com> wrote:

> On Mon, Apr 7, 2014 at 3:25 PM, Tony Luck <tony.luck@intel.com> wrote:
> 
> > c) If not this ... then what? Separate routine to convert large numbers
> >    of jiffies to usec/nsecs?  Should we make the existing one barf when
> >    handed a number that overflows?
> 
> Having thought about this a bit more - I'm leaning towards leaving
> jiffies_to_usecs() alone, but using it as a model for a from-scratch
> implementation of:
> u64 jiffies_to_nsecs(const unsigned long j)
> {
> }
> 
> This is what the uptime tracer actually needs - and there is only
> one user of jiffies_to_nsecs() to worry about.

Sounds good to me.

-- Steve
