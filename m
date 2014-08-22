Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbaHVRn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:43:29 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:44634 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932447AbaHVRn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:43:28 -0400
Date: Fri, 22 Aug 2014 12:43:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
In-Reply-To: <20140822164051.GB15713@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1408221241340.23099@gentwo.org>
References: <alpine.DEB.2.11.1408070959250.28468@gentwo.org> <20140821222212.GA7996@mtj.dyndns.org> <alpine.DEB.2.11.1408212001100.19762@gentwo.org> <20140822164051.GB15713@mtj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Tejun Heo wrote:

> On Thu, Aug 21, 2014 at 08:03:25PM -0500, Christoph Lameter wrote:
> > Its a pretty simple function (actually more a name substituion) so I
> > did not think it worth creating an inline function.
>
> Unless there are specific reasons like multi-type arg or breaking
> hellish definition order dependency, I think we're better off with
> inline functions, especially here, as the implementation will happily
> accept arguments of the wrong type.
>

It wont accept the wrong type since the this_cpu_* functions will do type
checking.

> > _t is there because I wanted to include the full "ugly" name of the
> > variable to make it similarly ugly. It is needed to make the clear
> > distinction to "struct cpumask *" which does not have these issues.
>
> The compiler can enforce that rule easily if the interface functions
> are properly typed.  I think it'd be far better to go with properly
> typed accessors with less unwieldy names.

What rule are we talking about? Accessors for what?

