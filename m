Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936189Ab3DHOFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:05:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934619Ab3DHOFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:05:50 -0400
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for
 !PREEMPT_COUNT
From: Steven Rostedt <srostedt@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFyFWjpSVQM6M266tKrG_ZXJzZ-nYejpmXYQXbrr42mGPQ@mail.gmail.com>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	 <1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	 <20130404152808.GB15261@ab42.lan> <515E54BD.2090300@synopsys.com>
	 <51602459.3040105@synopsys.com>
	 <CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
	 <51624591.4010303@synopsys.com>
	 <CA+55aFyFWjpSVQM6M266tKrG_ZXJzZ-nYejpmXYQXbrr42mGPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 08 Apr 2013 10:05:22 -0400
Message-ID: <1365429922.2733.4.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-04-07 at 21:48 -0700, Linus Torvalds wrote:

> Ingo? Peter? I'm not sure anybody really uses UP+no-preempt on x86,
> but it does seem to be a bug.. Comments?

I believe a lot of people still use no-preempt. Well, at least voluntary
preemption, which would have the same bug.

I'm thinking that we may have just been lucky that gcc didn't move the
get_user() into a place that would cause issues.

Sounds like a bug to me.

-- Steve


