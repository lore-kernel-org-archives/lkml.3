Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442Ab3ICW4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:56:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758490Ab3ICW4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:56:34 -0400
Date: Tue, 3 Sep 2013 18:55:28 -0400
From: Dave Jones <davej@redhat.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130903225528.GA14909@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andi Kleen <andi@firstfloor.org>,
	"Chandramouleeswaran, Aswin" <aswin@hp.com>,
	"Norton, Scott J" <scott.norton@hp.com>
References: <CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
 <CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
 <CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
 <CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
 <CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
 <CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
 <CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
 <CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
 <CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
 <CA+icZUXi-YHK23sKnVQbfi4K2FOVZiROQ76H5Qw2NxTJT2uzDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXi-YHK23sKnVQbfi4K2FOVZiROQ76H5Qw2NxTJT2uzDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 12:37:25AM +0200, Sedat Dilek wrote:
 
 > > You're spending more time on the task stats than on the actual lookup.
 > > Maybe you should turn off CONFIG_TASKSTATS..But why that whole
 > > irq_return thing? Odd.
 > >
 > 
 > [ init/Kconfig ]
 > ...
 > config TASKSTATS
 >         bool "Export task/process statistics through netlink"
 >         depends on NET <--- Difficult to disable it?!

More likely you're getting bitten by the fact that CONFIG_KVM has
a 'select TASKSTATS'

	Dave

