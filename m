Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3JIUqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:46:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:27944 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab3JIUqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:46:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1066,1371106800"; 
   d="scan'208";a="408486006"
Message-ID: <5255C07E.70805@linux.intel.com>
Date: Wed, 09 Oct 2013 13:45:50 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [RFC][PATCH] x86: Lazy disabling of interrupts
References: <20131009144150.108f7041@gandalf.local.home>
In-Reply-To: <20131009144150.108f7041@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Summary
> -------
> 
> Although the extreme case shows a nice improvement, I'm skeptical if it
> is worth doing for real world applications.

You did the experiment, and credit to you for not going "I did the work,
now include it" but rather for publishing the results so we can learn
from them.

It *does* make me wonder if we can leverage RTM for a significant subset
of these (as an interrupt will abort a transaction); that should be
substantially cheaper and less complex.

	-hpa

