Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaB0REo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:04:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:55368 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752068AbaB0REn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:04:43 -0500
Date: Thu, 27 Feb 2014 12:04:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Alex Elder <alex.elder@linaro.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andre Naujoks <nautsch2@gmail.com>, Jason Baron <jbaron@akamai.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@infradead.org>, Tony Luck <tony.luck@intel.com>,
        Alex Thorlton <athorlton@sgi.com>, Kees Cook <keescook@chromium.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/46] kernel: Add prototype definition to
 include/linux/kernel.h
Message-ID: <20140227120439.260e5a6b@gandalf.local.home>
In-Reply-To: <20140227164335.GB28589@thin>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	<644cc80558c61ce1f498393a77df366ad0d7b960.1393493276.git.rashika.kheria@gmail.com>
	<20140227113230.3e726bc7@gandalf.local.home>
	<20140227164335.GB28589@thin>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Dropped Chen Gang, Tony Lu, Chris Metcalf and Robin Holt as their
  emails are bouncing for me ]

On Thu, 27 Feb 2014 08:43:36 -0800
Josh Triplett <josh@joshtriplett.org> wrote:
 
> > > +void __weak panic_smp_self_stop(void);
> > 
> > Is __weak required in a prototype? What about the override that is not
> > weak.
> 
> That's a good question.  It's definitely not required, and should be
> dropped.  What I don't know is if it's broken to include it: does it
> make the non-weak definition weak?

I don't think so, but it is inconsistent. Best to not include it in the
prototype. This is a clean up patch after all. Lets not clean up one
thing and make something else messy in the process.

-- Steve
