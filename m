Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965917AbaFSVPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:15:48 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:48481 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965451AbaFSVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:15:46 -0400
Date: Thu, 19 Jun 2014 17:15:43 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140619211543.GD9814@mtj.dyndns.org>
References: <20140612135630.GA23606@htj.dyndns.org>
 <alpine.DEB.2.11.1406171401350.22064@gentwo.org>
 <20140617194017.GO4669@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191540240.4002@gentwo.org>
 <20140619204634.GB9814@mtj.dyndns.org>
 <alpine.DEB.2.11.1406191608290.5484@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406191608290.5484@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 04:11:47PM -0500, Christoph Lameter wrote:
> The aim of having percpu data is to have the ability for a processor to
> access memory dedicated to that processor in the fastest way possible by
> avoiding synchronization. You are beginning to add synchronization
> elements into the accesses of a processor to memory dedicated to its sole
> use.

Again, data dependency barrier is noop in all in-use archs.

> Remote write events are contrary to that design and are exceedingly rare.
> An IPI is justifiable for such a rare event. At least in my use cases I
> have always found that to be sufficient. Well, I designed the data
> structures in a way that made this possible because of the design criteria
> that did not allow me remote write access to other processors per cpu
> data.

You're repeatedly getting wayside in the discussion.  What are you
suggesting?  Sending IPIs on each percpu allocation?

Again, I'm leaning towards just clarifying the init write ownership to
the allocating CPU as that seems the most straight forward way to deal
with it, but please stop brining up the raw performance thing.  Nobody
is doing anything to that.  It's not relevant in the discussion.

Thanks.

-- 
tejun
