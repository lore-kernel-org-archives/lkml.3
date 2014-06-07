Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaFGGqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 02:46:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaFGGqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 02:46:22 -0400
Date: Fri, 6 Jun 2014 23:45:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: David Laight <David.Laight@aculab.com>,
        "'Ken Helias'" <kenhelias@firemail.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "b.a.t.m.a.n@lists.open-mesh.org" <b.a.t.m.a.n@lists.open-mesh.org>,
        "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>
Subject: Re: [PATCH] list: Fix order of arguments for hlist_add_after(_rcu)
Message-Id: <20140606234501.b950d5d0.akpm@linux-foundation.org>
In-Reply-To: <20140606172250.GN4581@linux.vnet.ibm.com>
References: <1402047743-3391-1-git-send-email-kenhelias@firemail.de>
	<063D6719AE5E284EB5DD2968C1650D6D17258AEA@AcuExch.aculab.com>
	<20140606172250.GN4581@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014 10:22:51 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Fri, Jun 06, 2014 at 03:56:52PM +0000, David Laight wrote:
> > From: Behalf Of Ken Helias
> > > All other add functions for lists have the new item as first argument and the
> > > position where it is added as second argument. This was changed for no good
> > > reason in this function and makes using it unnecessary confusing.
> > > 
> > > Also the naming of the arguments in hlist_add_after was confusing. It was
> > > changed to use the same names as hlist_add_after_rcu.
> > ...
> > > -static inline void hlist_add_after_rcu(struct hlist_node *prev,
> > > -				       struct hlist_node *n)
> > > +static inline void hlist_add_after_rcu(struct hlist_node *n,
> > > +				       struct hlist_node *prev)
> > 
> > It is rather a shame that the change doesn't generate a compilation
> > error for old source files.
> 
> I am also a bit concerned by this.
> 

yup.  hlist_add_behind()?
