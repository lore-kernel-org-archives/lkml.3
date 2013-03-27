Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3C0ORu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:17:50 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41202
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716Ab3C0ORs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:17:48 -0400
Message-ID: <1364393852.5053.74.camel@laptop>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
From: Peter Zijlstra <peterz@infradead.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        paulmck <paulmck@us.ibm.com>
Date: Wed, 27 Mar 2013 15:17:32 +0100
In-Reply-To: <20130327131532.GL30540@8bytes.org>
References: <20130324115556.GA4866@pd.tnic> <20130324155924.GB4866@pd.tnic>
	 <20130326183452.GC27518@pd.tnic> <20130327131532.GL30540@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 14:15 +0100, Joerg Roedel wrote:
> What makes me wonder here is that the code is preemptible in an
> rcu_read_locked section. As far as I know preemption needs to be
> disabled while holding the rcu_read_lock().

Nah, a long long time ago some -rt people complained to paulmck that
keeping preemption disabled over all this RCU stuff was killing
latencies. Paul liked the challenge and came up with some mind twisting
stuff to make it work.

If you're into that kind of pain, look at CONFIG_*_PREEMPT_RCU :-)

But yeah, you need to have that stuff enabled before you can hit this
particular snag.

