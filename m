Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaFFRXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:23:00 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37420 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbaFFRW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:22:56 -0400
Date: Fri, 6 Jun 2014 10:22:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Laight <David.Laight@aculab.com>
Cc: "'Ken Helias'" <kenhelias@firemail.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "b.a.t.m.a.n@lists.open-mesh.org" <b.a.t.m.a.n@lists.open-mesh.org>,
        "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>
Subject: Re: [PATCH] list: Fix order of arguments for hlist_add_after(_rcu)
Message-ID: <20140606172250.GN4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402047743-3391-1-git-send-email-kenhelias@firemail.de>
 <063D6719AE5E284EB5DD2968C1650D6D17258AEA@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17258AEA@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060617-3532-0000-0000-0000024D88C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 03:56:52PM +0000, David Laight wrote:
> From: Behalf Of Ken Helias
> > All other add functions for lists have the new item as first argument and the
> > position where it is added as second argument. This was changed for no good
> > reason in this function and makes using it unnecessary confusing.
> > 
> > Also the naming of the arguments in hlist_add_after was confusing. It was
> > changed to use the same names as hlist_add_after_rcu.
> ...
> > -static inline void hlist_add_after_rcu(struct hlist_node *prev,
> > -				       struct hlist_node *n)
> > +static inline void hlist_add_after_rcu(struct hlist_node *n,
> > +				       struct hlist_node *prev)
> 
> It is rather a shame that the change doesn't generate a compilation
> error for old source files.

I am also a bit concerned by this.

							Thanx, Paul

