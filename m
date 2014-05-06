Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaEFQKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:10:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48111 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbaEFQKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:10:09 -0400
Date: Tue, 6 May 2014 18:10:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Slow down stupid pounders
Message-ID: <20140506161004.GC25013@pd.tnic>
References: <20140506102924.GA25013@pd.tnic>
 <1399388899.5192.273.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1399388899.5192.273.camel@marge.simpson.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 05:08:19PM +0200, Mike Galbraith wrote:
> Rather than ratelimit the interface perhaps send a ratelimited note
> telling the user straight up that he's begging for trouble. We can
> ignore it when regression testing, and point it out to Joe Pounder
> should he fail to notice.. or be somewhat dense.

Yeah, if those dudes don't stare at dmesg, that note doesn't bring us
whit.

Alternatively, we could do

	add_taint(TAINT_HOTPLUG_POUNDER)

when the rate is exceeded...

I'd rather like to slow it down for a second, though, if it doesn't hurt
any sensible use cases in doing so.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
