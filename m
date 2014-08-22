Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaHVBD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:03:29 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:58612
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487AbaHVBD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:03:28 -0400
Date: Thu, 21 Aug 2014 20:03:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
In-Reply-To: <20140821222212.GA7996@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1408212001100.19762@gentwo.org>
References: <alpine.DEB.2.11.1408070959250.28468@gentwo.org> <20140821222212.GA7996@mtj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Tejun Heo wrote:

> >
> > +#define this_cpu_cpumask_var_t_ptr(x) this_cpu_ptr(&x)
>
> Urgh, this is nasty but yeah I can't think of any other way around it
> either. :(
>
> Do we need the "_t" in the name tho?  Maybe we can shorten the name to
> this_cpumask_var_ptr(x)?  Also, wouldn't it be better to define it as
> a static inline function so that the input type is explicit?

Its a pretty simple function (actually more a name substituion) so I
did not think it worth creating an inline function.

_t is there because I wanted to include the full "ugly" name of the
variable to make it similarly ugly. It is needed to make the clear
distinction to "struct cpumask *" which does not have these issues.


