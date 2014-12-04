Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaLDABn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:01:43 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57883 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaLDABm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:01:42 -0500
Date: Thu, 4 Dec 2014 01:01:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] context_tracking: Restore previous state in
 schedule_user
Message-ID: <20141204000137.GF31369@lerouge>
References: <20141203220836.GC31369@lerouge>
 <e840280bba54050816470caa870bd9f561efc545.1417649608.git.luto@amacapital.net>
 <20141203235002.GW25340@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141203235002.GW25340@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 03:50:02PM -0800, Paul E. McKenney wrote:
> On Wed, Dec 03, 2014 at 03:37:08PM -0800, Andy Lutomirski wrote:
> > It appears that some SCHEDULE_USER (asm for schedule_user) callers
> > in arch/x86/kernel/entry_64.S are called from RCU kernel context,
> > and schedule_user will return in RCU user context.  This causes RCU
> > warnings and possible failures.
> > 
> > This is intended to be a minimal fix suitable for 3.18.
> > 
> > Reported-and-tested-by: Dave Jones <davej@redhat.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> > Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> 
> Looks like the RCU entry/exit stuff is properly accounted for, so:
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks a lot guys!

I'll take the patch. This just won't go for 3.18 I think, the issue
is there since the early days of context tracking.
