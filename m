Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaKJVIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:08:30 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43315 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaKJVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:08:28 -0500
Date: Mon, 10 Nov 2014 22:08:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20141110210821.GF10501@worktop.programming.kicks-ass.net>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-11-git-send-email-matt@console-pimps.org>
 <20141107122052.GD3337@twins.programming.kicks-ass.net>
 <20141110205653.GF1292@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110205653.GF1292@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 08:56:53PM +0000, Matt Fleming wrote:
> > Should we initialize that to a finite value? Surely results are absolute
> > crap if we do indeed reach that max?
> 
> I don't think we'll ever reach that max, it'll bottom out once it
> reaches the size of the LLC, since the pathological case is that the
> RMID you're currently trying to stabilize is used to tag every line in
> the LLC.

Sure, LLC size is the 'same'. Makes the entire ordeal rather pointless.

> Not sure what a reasonable finite value would be here though? 10% of the
> LLC size?

Can you ask the same Oracle that provided the magic 250 ms? Both are
magic/random numbers. 10% sounds rather large, but who knows.
