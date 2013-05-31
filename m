Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3EaXHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:07:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab3EaXHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 19:07:38 -0400
Date: Fri, 31 May 2013 16:07:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: liguang <lig.fnst@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] sys: remove unnecesscary parameter of set_one_prio
Message-Id: <20130531160736.c4588108643abe14e5bfa455@linux-foundation.org>
In-Reply-To: <1369901305.22004.138.camel@joe-AO722>
References: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
	<1369901305.22004.138.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 01:08:25 -0700 Joe Perches <joe@perches.com> wrote:

> On Thu, 2013-05-30 at 15:58 +0800, liguang wrote:
> []
> > diff --git a/kernel/sys.c b/kernel/sys.c
> []
> > -static int set_one_prio(struct task_struct *p, int niceval, int error)
> > +static int set_one_prio(struct task_struct *p, int niceval)
> 
> Umm, error is forwarded through do_each loops.
> 
> Are you sure you can do this without
> changing any return code behaviors?

yes, you're right.  The first time around, -ESRCH gets rewritten to 0
and the zero propagates, as long as nobody hits an error which isn't
-ESRCH.  I'm not sure this was the most straightforward possible
implementation :(

