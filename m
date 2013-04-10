Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936099Ab3DJHMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:12:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47654 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3DJHMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:12:40 -0400
Message-ID: <1365577957.30071.13.camel@laptop>
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for
 !PREEMPT_COUNT
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <srostedt@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 10 Apr 2013 09:12:37 +0200
In-Reply-To: <CA+55aFysegA0nYxu4DYugz6R+wP6c1oDOemHpMT7av645S+cVg@mail.gmail.com>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	 <1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	 <20130404152808.GB15261@ab42.lan> <515E54BD.2090300@synopsys.com>
	 <51602459.3040105@synopsys.com>
	 <CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
	 <51624591.4010303@synopsys.com>
	 <CA+55aFyFWjpSVQM6M266tKrG_ZXJzZ-nYejpmXYQXbrr42mGPQ@mail.gmail.com>
	 <1365428274.2609.160.camel@laptop> <1365431470.2733.16.camel@fedora>
	 <CA+55aFx88-t_pm5hbxbrrhqm3_=+JQussO=zD1kT+05UVCAFCA@mail.gmail.com>
	 <1365433142.2733.18.camel@fedora>
	 <CA+55aFyea-YdNP-=fyV2JMoN2cyv9Vpp3-e4p86V+7OSBQAV5Q@mail.gmail.com>
	 <CA+55aFysegA0nYxu4DYugz6R+wP6c1oDOemHpMT7av645S+cVg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 07:32 -0700, Linus Torvalds wrote:
> Something like the attached (still untested, although it seems to at
> least compile) patch. Comments?

Yes, makes me feel far more comfortable than this "asm volatile"
business (which as you noted has holes in it).

