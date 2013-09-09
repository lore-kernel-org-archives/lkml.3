Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3IIMoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:44:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49860 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab3IIMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:44:07 -0400
Date: Mon, 9 Sep 2013 14:43:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] x86/UV: Add ability to disable UV NMI handler
Message-ID: <20130909124349.GY31370@twins.programming.kicks-ass.net>
References: <20130905225032.879120272@asylum.americas.sgi.com>
 <20130905225034.343366161@asylum.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905225034.343366161@asylum.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 05:50:41PM -0500, Mike Travis wrote:
> For performance reasons, the NMI handler may be disabled to lessen the
> performance impact caused by the multiple perf tools running concurently.
> If the system nmi command is issued when the UV NMI handler is disabled,
> the "Dazed and Confused" messages occur for all cpus.  The NMI handler is
> disabled by setting the nmi disabled variable to '1'.  Setting it back to
> '0' will re-enable the NMI handler.

I'm not entirely sure why this is still needed now that you've moved all
really expensive bits into the UNKNOWN handler.
