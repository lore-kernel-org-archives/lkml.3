Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaHWROW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 13:14:22 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:34559 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaHWROV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 13:14:21 -0400
Date: Sat, 23 Aug 2014 13:14:16 -0400
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
Message-ID: <20140823171416.GG13540@mtj.dyndns.org>
References: <alpine.DEB.2.11.1408070959250.28468@gentwo.org>
 <20140821222212.GA7996@mtj.dyndns.org>
 <alpine.DEB.2.11.1408212001100.19762@gentwo.org>
 <20140822164051.GB15713@mtj.dyndns.org>
 <alpine.DEB.2.11.1408221241340.23099@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408221241340.23099@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Fri, Aug 22, 2014 at 12:43:25PM -0500, Christoph Lameter wrote:
> It wont accept the wrong type since the this_cpu_* functions will do type
> checking.

It should only accept cpumask_var_t but the macro version accepts
anything that this_cpu_*() can handle.

> > > _t is there because I wanted to include the full "ugly" name of the
> > > variable to make it similarly ugly. It is needed to make the clear
> > > distinction to "struct cpumask *" which does not have these issues.
> >
> > The compiler can enforce that rule easily if the interface functions
> > are properly typed.  I think it'd be far better to go with properly
> > typed accessors with less unwieldy names.
> 
> What rule are we talking about? Accessors for what?

I meant that if the new accessors you're adding are proper inline
functions, the compiler would be able to verify the specific type they
should take.  IOW, let's go for shorter name w/ stricter type
checking.

Thanks.

-- 
tejun
