Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaLEF7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:59:54 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:53410 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaLEF7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:59:17 -0500
X-Originating-IP: 50.43.43.148
Date: Thu, 4 Dec 2014 21:59:09 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tinification: Make SRCU optional by using CONFIG_SRCU
Message-ID: <20141205055909.GA19116@thin>
References: <1417737024-13967-1-git-send-email-bobby.prani@gmail.com>
 <20141205001148.GC25340@linux.vnet.ibm.com>
 <548112D8.70009@cn.fujitsu.com>
 <CAJhHMCD7GVUcGsex86Tj-+oVh5a6qpmtTt88Nb8ZJj-SGYz9Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCD7GVUcGsex86Tj-+oVh5a6qpmtTt88Nb8ZJj-SGYz9Nw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:30:20PM -0500, Pranith Kumar wrote:
> On Thu, Dec 4, 2014 at 9:05 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > On 12/05/2014 08:11 AM, Paul E. McKenney wrote:
> >> On Thu, Dec 04, 2014 at 06:50:24PM -0500, Pranith Kumar wrote:
> >>>
> >>> +config SRCU
> >>> +    bool "Sleepable form of RCU"
> >
> > Why it has a title? Somebody need to select it manually for third party kernel module?
> 
> Yes, it is a choice given to enable SRCU even when no in-kernel module uses it.

That makes sense for testing purposes, but I don't think it makes sense
for the final patch.  I'd suggest making it a completely automatic
symbol with no title.

> >
> >>> +    def_bool n

You already say "bool" above, and "default n" is the default default, so
you can omit this line entirely.

- Josh Triplett
