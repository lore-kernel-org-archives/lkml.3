Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaFYKBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:01:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbaFYKBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:01:54 -0400
Date: Wed, 25 Jun 2014 12:01:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Konstantin Khlebnikov <koct9i@gmail.com>
cc: =?ISO-8859-15?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
In-Reply-To: <CALYGNiM3OH64ULh63cCarTitbjUatZP0mckJ3N9CDusP3mFMRg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1406251200051.15939@pobox.suse.cz>
References: <20140619213329.478113470@goodmis.org> <alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz> <20140619185810.4137e14b@gandalf.local.home> <alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz> <20140619191923.1365850a@gandalf.local.home>
 <alpine.LNX.2.00.1406200123220.15014@pobox.suse.cz> <20140619193635.1949b469@gandalf.local.home> <alpine.LNX.2.00.1406200137310.15014@pobox.suse.cz> <20140620143525.GB8769@pathway.suse.cz>
 <CALYGNiM3OH64ULh63cCarTitbjUatZP0mckJ3N9CDusP3mFMRg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Konstantin Khlebnikov wrote:

> Originally I thought that seizing all cpus one by one and printing from 
> the initiator is a best approach and I've started preparing arguments 
> against over-engineered printk...

By "seizing" I guess you mean sending IPI, right?

What do you do if you'd interrupt it in the middle of printk() in order 
not to deadlock by trying to take the buffer lock on the initiator CPU?

-- 
Jiri Kosina
SUSE Labs
