Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaIDFOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:14:19 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:62125 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaIDFOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:14:16 -0400
Date: Thu, 4 Sep 2014 07:14:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/26] locking: Add non-fatal spin lock assert
Message-ID: <20140904051411.GA27350@gmail.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1409693975-1028-14-git-send-email-peter@hurleysoftware.com>
 <20140903092723.GA4783@worktop.ger.corp.intel.com>
 <5406F964.6060900@hurleysoftware.com>
 <20140903144029.GA7083@twins.programming.kicks-ass.net>
 <54072A99.1080306@hurleysoftware.com>
 <20140903150729.GA7436@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903150729.GA7436@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Sep 03, 2014 at 10:50:01AM -0400, Peter Hurley wrote:
> > So a lockdep-only assert is unlikely to draw attention to existing bugs,
> > especially in established drivers.
> 
> By the same logic lockdep will not find locking errors in established
> drivers.

Indeed, this patch is ill-advised in several ways:

  - it extends an API variant that we want to phase

  - emits a warning even if say lockdep has already emitted a
    warning and locking state is not guaranteed to be consistent. 

  - makes the kernel more expensive once fully debugged, in that
    non-fatal checks are unconditional.

Also please submit locking related patches as standalone series 
to the locking subsystem, not embedded in an unrelated series.

Thanks,

	Ingo
