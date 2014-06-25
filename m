Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbaFYL5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:57:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbaFYL5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:57:49 -0400
Date: Wed, 25 Jun 2014 13:57:45 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
Message-ID: <20140625115745.GK8769@pathway.suse.cz>
References: <20140619185810.4137e14b@gandalf.local.home>
 <alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz>
 <20140619191923.1365850a@gandalf.local.home>
 <alpine.LNX.2.00.1406200123220.15014@pobox.suse.cz>
 <20140619193635.1949b469@gandalf.local.home>
 <alpine.LNX.2.00.1406200137310.15014@pobox.suse.cz>
 <20140620143525.GB8769@pathway.suse.cz>
 <CALYGNiM3OH64ULh63cCarTitbjUatZP0mckJ3N9CDusP3mFMRg@mail.gmail.com>
 <alpine.LNX.2.00.1406251200051.15939@pobox.suse.cz>
 <CALYGNiOT9XkiE1Q=AimOt42UkQ430Qy89cseNLVaMf96O9=FJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYGNiOT9XkiE1Q=AimOt42UkQ430Qy89cseNLVaMf96O9=FJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-06-25 15:04:41, Konstantin Khlebnikov wrote:
> On Wed, Jun 25, 2014 at 2:01 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> > On Tue, 24 Jun 2014, Konstantin Khlebnikov wrote:
> 
> I like that context-depend printk routing from this patchset.
> I'm just not quite happy with this straight forward implementation.
> Rerouting flow into different buffers might serve different purposes,
> it must make code simpler instead of adding yet another knot.
> For example printk continuation might use it too.

Note that we could not share the buffer between normal and NMI
context easily. We would end with the same locking problems as we have now.

In fact, any sharing is complicated when NMI is involved, especially
when we need to access the data from both NMI and normal context.
And we need to copy them into the main ring buffer in a normal context.

This patchset works only because arch_trigger_all_cpu_backtrace() is
called from normal context. Also all other calls are ignored until the
previous call is finished, see "backtrace_flag".


Best Regards,
Petr
