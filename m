Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaFDSM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:12:27 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:33139 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaFDSM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:12:26 -0400
Date: Wed, 4 Jun 2014 14:12:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] last minute percpu fix for v3.15-rc8
Message-ID: <20140604181214.GM5004@htj.dyndns.org>
References: <20140604163700.GH5004@htj.dyndns.org>
 <alpine.DEB.2.10.1406041215180.12469@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406041215180.12469@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 04, 2014 at 12:16:56PM -0500, Christoph Lameter wrote:
> On Wed, 4 Jun 2014, Tejun Heo wrote:
> 
> > I'll ping Christoph whether __this_cpu_*() ops can be better annotated
> > so that it can trigger lockdep warning when used from multiple
> > contexts.
> 
> We just added checks that verify the proper preemption mode for
> __this_cpu operations. That did not catch it?

That one just ensures that __this_cpu_*() are called with preemption
disabled.  What's necessary is tracking whether each percpu variable
is operated on from different contexts so that things like
"inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage" lockdep warnings
can be triggered in cases like this.

Given that percpu operations can be performed on any allocated percpu
area, it's a bit difficult to achieve tho.  The only way I can think
of is percpu allocator creating lockdep key for all the allocated
offsets which isn't too enticing. :(

Thanks.

-- 
tejun
