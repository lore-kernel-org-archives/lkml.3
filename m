Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611AbaGUTep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 15:34:45 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47709 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933568AbaGUTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 15:34:44 -0400
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <53CD6B50.5010404@mit.edu>
Date: Mon, 21 Jul 2014 12:34:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
References: <20140719130602.GA5101@pd.tnic>
In-Reply-To: <20140719130602.GA5101@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2014 06:06 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> There are machines which do have stable and always-running TSCs but the
> last get started at different points in time by the platform, causing
> the TSCs to have a small constant diff.
> 
> It has been tried a couple of times to resync those during that
> sync check but the procedure is error prone and flaky, and not 100%
> successful.
> 
> So, instead of doing that, let's not touch the TSCs at all but save a
> per-CPU TSC offset which we add to the TSC value we've read from the
> Time-Stamp Counter. The hope is thus to still salvage the TSC on those
> machines.
> 
> For that to work, we need to populate the TSC AUX MSR with the core ID
> prior to doing the TSC sync check so that RDTSCP can give us the correct
> core number and we can add the offset atomically. And yes, we need a
> X86_FEATURE_RDTSCP CPU for the whole deal to work. Older ones simply
> lose.

I'm sure I'm missing something, but where is tsc_offset used outside the
tsc startup code?  Is it somehow getting programmed into the TSC config
registers?

--Andy
