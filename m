Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaLDAaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:30:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaLDAai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:30:38 -0500
Date: Wed, 3 Dec 2014 19:30:24 -0500
From: Dave Jones <davej@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] context_tracking: Restore previous state in schedule_user
Message-ID: <20141204003024.GA17665@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <20141203220836.GC31369@lerouge>
 <c6a6c2246188d25b9997848bbf39d5363c7a3da9.1417648389.git.luto@amacapital.net>
 <20141203235835.GE31369@lerouge>
 <CALCETrXbEheevmNKsuEd0NEpCrDz06W5z_OphMOUHqT7qNUTyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrXbEheevmNKsuEd0NEpCrDz06W5z_OphMOUHqT7qNUTyA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 04:04:31PM -0800, Andy Lutomirski wrote:
 > On Wed, Dec 3, 2014 at 3:58 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
 > > On Wed, Dec 03, 2014 at 03:18:41PM -0800, Andy Lutomirski wrote:
 > >> It appears that some SCHEDULE_USER (asm for schedule_user) callers
 > >> in arch/x86/kernel/entry_64.S are called from RCU kernel context,
 > >> and schedule_user will return in RCU user context.  This causes RCU
 > >> warnings and possible failures.
 > >>
 > >> This is intended to be a minimal fix suitable for 3.18.
 > >>
 > >> Reported-by: Dave Jones <davej@redhat.com>
 > >> Cc: Oleg Nesterov <oleg@redhat.com>
 > >> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
 > >> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
 > >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
 > >
 > > Ah, we sent it about at the same time :-)
 > >
 > > Might be too late for 3.18 though because it's not a regression.

Wait, so how come that trace didn't start showing up until recently ?

	Dave

