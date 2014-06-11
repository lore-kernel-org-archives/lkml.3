Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaFKEmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:42:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48734 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaFKEmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:42:47 -0400
Date: Tue, 10 Jun 2014 21:42:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] kernel/rcu/tree.c: correct a check for grace
 period in progress
Message-ID: <20140611044242.GY4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402456819-30515-1-git-send-email-bobby.prani@gmail.com>
 <20140611041202.GX4581@linux.vnet.ibm.com>
 <CAJhHMCCgXBCe-deg7TtqA-azyc2ZvQRLKAiKVJ5OhL5GzLhH0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCCgXBCe-deg7TtqA-azyc2ZvQRLKAiKVJ5OhL5GzLhH0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061104-9332-0000-0000-0000010F0677
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:23:57AM -0400, Pranith Kumar wrote:
> Hi Paul,
> 
> On Wed, Jun 11, 2014 at 12:12 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >>       if (rnp->gpnum != rnp->completed ||
> >> -         ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
> >> +         ACCESS_ONCE(rnp_root->gpnum) != ACCESS_ONCE(rnp_root->completed)) {
> >
> > At this point in the code, we are checking the current rcu_node structure,
> > which might or might not be the root.  If it is not the root, we absolutely
> > cannot compare against the root because we don't yet hold the root's lock.
> >
> 
> I was a bit thrown by the double checking which is being done
> (rnp->gpnum != rnp->complete) in that if condition. Once without
> ACCESS_ONCE and one with. Is there any particular reason for this?
> 
> I now understand that we are comparing ->gpnum and ->completed of the
> root node which might change from under us if we don't hold the root's
> lock. I will keep looking :)

Hmmm...  Now that you mention it, that does look a bit strange.

							Thanx, Paul

