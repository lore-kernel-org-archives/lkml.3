Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3CAVnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:43:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3CAVnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:43:23 -0500
Date: Fri, 1 Mar 2013 13:43:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] printk: Avoid softlockups in console_unlock()
Message-Id: <20130301134321.85e18987.akpm@linux-foundation.org>
In-Reply-To: <20130301103027.GC26128@quack.suse.cz>
References: <1361927819-1570-1-git-send-email-jack@suse.cz>
	<20130227175945.GC3336@linux.vnet.ibm.com>
	<20130301103027.GC26128@quack.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Mar 2013 11:30:27 +0100
Jan Kara <jack@suse.cz> wrote:

> > If a CPU remains in your loop where you invoke rcu_cpu_stall_reset(),
> > there is no indication of the stall.  Now, I do understand why having
> > RCU add a CPU stall warning into the mix would be very bad, but it
> > would be good to have some sort of indication that there is stalling.
> > Perhaps a counter visible in sysfs?  Whatever it is, at least some way
> > of diagnosing the stall condition would be very good.
>   I see. If others (Andrew, ping?) are OK with the rest of the patch, I can
> extend it and add a counter of printk() breaks we had to make. That looks
> like a good idea.

hmpf, spose so.  It sound lke the world's least interesting counter but
perhaps it will look more interesting when we see its sparkly
documentation.
