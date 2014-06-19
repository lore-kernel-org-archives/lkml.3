Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376AbaFSUqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:46:39 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:51077 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964975AbaFSUqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:46:37 -0400
Date: Thu, 19 Jun 2014 16:46:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140619204634.GB9814@mtj.dyndns.org>
References: <20140612135630.GA23606@htj.dyndns.org>
 <alpine.DEB.2.11.1406171401350.22064@gentwo.org>
 <20140617194017.GO4669@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191540240.4002@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406191540240.4002@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 03:42:07PM -0500, Christoph Lameter wrote:
> In that case special care needs to be taken to get this right. True.
> 
> I typically avoid these scenarios by sending an IPI with a pointer to the
> data structure. The modification is done by the cpu for which the per cpu
> data is local.
> 
> Maybe rewrite the code to avoid writing to other processors percpu data
> would be the right approach?

It depends on the specific use case but in general no.  IPIs would be
far more expensive than making use of proper barriers in vast majority
of cases especially when the "hot" side is data dependency barrier,
IOW, nothing.  Also, we are talking about extremely low frequency
events like init and recycling after reinit.  Regular per-cpu
operation isn't really the subject here.

Thanks.

-- 
tejun
