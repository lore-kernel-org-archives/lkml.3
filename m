Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaFXApn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:45:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaFXApm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:45:42 -0400
Date: Mon, 23 Jun 2014 17:45:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        hpa@linux.intel.com, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v8 4/4] printk: allow increasing the ring buffer
 depending on the number of CPUs
Message-Id: <20140623174533.88663e64.akpm@linux-foundation.org>
In-Reply-To: <20140624002050.GC27687@wotan.suse.de>
References: <1403124337-14886-1-git-send-email-mcgrof@do-not-panic.com>
	<1403124337-14886-4-git-send-email-mcgrof@do-not-panic.com>
	<20140623154134.43ac7ab63896cd9ebcba84b6@linux-foundation.org>
	<20140624002050.GC27687@wotan.suse.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 02:20:50 +0200 "Luis R. Rodriguez" <mcgrof@suse.com> wrote:

> On Mon, Jun 23, 2014 at 03:41:34PM -0700, Andrew Morton wrote:
> > On Wed, 18 Jun 2014 13:45:37 -0700 "Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
> > 
> > > ...
> > >
> > > If an increase is required the ring buffer is increased to
> > > +	  the next power of 2 that can fit both the minimum kernel ring buffer
> > > +	  (LOG_BUF_SHIFT) plus the additional worst case CPU contributions.
> > >
> > > ...
> > >
> > > +	log_buf_len_update(cpu_extra + __LOG_BUF_LEN);
> > > +}
> > 
> > I'd have expected
> > 
> >   total_cpu_space = minimum-per-cpu-len * nr_possible_cpus;
> >   log_buf_len = max(__LOG_BUF_LEN, total_cpu_space)
> > 
> > but here you added __LOG_BUF_LEN to total_cpu_space and I cannot work
> > out why.  
> > .
> 
> Ah, because its cpu_extra, not total_cpu_space that is being
> computed, the goal was to see how much extra junk on the
> worst case a CPU might contribute. The __LOG_BUF_LEN is the
> default size, so we combine both.

Well...  why?  Isn't it simpler and more direct to say "I want at least
32k per CPU"?
