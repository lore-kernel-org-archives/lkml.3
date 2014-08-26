Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaHZVdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:33:32 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:34087 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbaHZVdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:33:31 -0400
Date: Tue, 26 Aug 2014 16:33:28 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
In-Reply-To: <alpine.DEB.2.11.1408231500430.31459@gentwo.org>
Message-ID: <alpine.DEB.2.11.1408261631350.8819@gentwo.org>
References: <alpine.DEB.2.11.1408070959250.28468@gentwo.org> <20140821222212.GA7996@mtj.dyndns.org> <alpine.DEB.2.11.1408212001100.19762@gentwo.org> <20140822164051.GB15713@mtj.dyndns.org> <alpine.DEB.2.11.1408221241340.23099@gentwo.org>
 <20140823171416.GG13540@mtj.dyndns.org> <alpine.DEB.2.11.1408231500430.31459@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2014, Christoph Lameter wrote:

> On Sat, 23 Aug 2014, Tejun Heo wrote:
>
> > Hello, Christoph.
> >
> > On Fri, Aug 22, 2014 at 12:43:25PM -0500, Christoph Lameter wrote:
> > > It wont accept the wrong type since the this_cpu_* functions will do type
> > > checking.
> >
> > It should only accept cpumask_var_t but the macro version accepts
> > anything that this_cpu_*() can handle.
>
> Ah, Ok.

Ok I tried to change it to an inline function. The problem is the
cpumask.h is included very early. this_cpu ops require functionality
that is not available at that point. I think it cannot be more than a
macro unless we define it elsewhere.

Regarding naming:

this_cpu_ptr_cpumask_var()

is ok?

