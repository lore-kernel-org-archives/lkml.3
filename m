Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaKUO7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:59:36 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:54201 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147AbaKUO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:59:35 -0500
Date: Fri, 21 Nov 2014 16:58:17 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com
Subject: Re: [PATCH tip/core/rcu 3/9] drivers/md: Use rcu_dereference() for
 accessing rcu pointer
Message-ID: <20141121145817.GA17710@node.dhcp.inet.fi>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414534202-27312-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20141121133145.GA17245@node.dhcp.inet.fi>
 <546F4C8C.4040904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546F4C8C.4040904@gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 09:30:36AM -0500, Pranith Kumar wrote:
> On 11/21/2014 08:31 AM, Kirill A. Shutemov wrote:
> > On Tue, Oct 28, 2014 at 03:09:56PM -0700, Paul E. McKenney wrote:
> >> From: Pranith Kumar <bobby.prani@gmail.com>
> >>
> >> Got Paul's email wrong the first time.
> >>
> >> The map field in 'struct mapped_device' is an rcu pointer. Use rcu_dereference()
> >> while accessing it.
> >>
> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > On current -next I see this:
> > 
> > [    6.388264] ===============================
> > [    6.389571] [ INFO: suspicious RCU usage. ]
> > [    6.390869] 3.18.0-rc5-next-20141121-08303-g44cae4530372 #2 Not tainted
> > [    6.392185] -------------------------------
> > [    6.393479] /home/kas/git/public/linux/drivers/md/dm.c:2853 suspicious rcu_dereference_check() usage!
> > [    6.394801] 
> > other info that might help us debug this:
> > 
> 
> Hi Kirill,
> 
> We are dereferencing an RCU pointer with the suspend_lock held which is causing this warning.
> 
> Can you please check if the following patch helps? Thanks!

Nope. The same issue.

IIUC, the problem is that you dereference pointer outside rcu_read_lock()
section, not that suspend_lock is held.

-- 
 Kirill A. Shutemov
