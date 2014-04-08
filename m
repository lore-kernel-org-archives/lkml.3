Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbaDHFex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 01:34:53 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63398 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaDHFew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 01:34:52 -0400
MIME-Version: 1.0
In-Reply-To: <0214020@agluck-desk.sc.intel.com>
References: <0214020@agluck-desk.sc.intel.com>
Date: Mon, 7 Apr 2014 22:34:51 -0700
Message-ID: <CA+8MBb+E_zT47qu4a6pqQWArrhs0gv1W=JKoy252_-Uw6HfbkA@mail.gmail.com>
Subject: Re: [RFC PATCH] time: Fix truncation in jiffies_to_usecs()
From: Tony Luck <tony.luck@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 3:25 PM, Tony Luck <tony.luck@intel.com> wrote:

> c) If not this ... then what? Separate routine to convert large numbers
>    of jiffies to usec/nsecs?  Should we make the existing one barf when
>    handed a number that overflows?

Having thought about this a bit more - I'm leaning towards leaving
jiffies_to_usecs() alone, but using it as a model for a from-scratch
implementation of:
u64 jiffies_to_nsecs(const unsigned long j)
{
}

This is what the uptime tracer actually needs - and there is only
one user of jiffies_to_nsecs() to worry about.

-Tony
