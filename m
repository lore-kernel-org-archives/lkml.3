Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbaGQOzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:55:37 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:43650 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933006AbaGQOzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:55:31 -0400
Date: Thu, 17 Jul 2014 09:55:29 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] doc: Add remote CPU access details and others to
 this_cpu_ops.txt
In-Reply-To: <53C7E234.3020503@gmail.com>
Message-ID: <alpine.DEB.2.11.1407170953070.28248@gentwo.org>
References: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1407170848490.27584@gentwo.org> <53C7D93B.4090006@gmail.com> <alpine.DEB.2.11.1407170934220.28121@gentwo.org> <53C7E234.3020503@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Pranith Kumar wrote:

> > The RCU code has .... ummmm... some issues with percpu usage and should
> > not be taken as a good example. If you look at the RCU code it looks
> > horrible with numerous barriers around remote percpu read/wrirte
> > accesses and one wonders if that code is actually ok.
>
> Well, it is running in all our kernels with not many reported issues, isn't it ;)
> And yes, that is one of the extra-ordinary situations where we use per-cpu data.
> Once you've extracted a pointer to the per-cpu area -and- ensure that concurrent
> accesses do not happen(or happen with enough guarantees using barriers), what is
> the case against remote accesses? I am asking from a correctness and a
> performance point of view, not style/aesthetics.

Could be working but I do not want it to be mentioned in the
documentation given the problems it causes. IPI is preferable.

> >> If data needs to be modified from multiple cpus only very rarely, doesn't it
> >> make sense to use per-cpu areas?
> >
> > I would suggest that this should not occur. You can always "modify" remote
> > percpu areas by generating an IPI on that cpu to make that processor
> > update its own per cpu data.
> >
>
> The case against doing that is not to wake up CPUs which are in idle/sleep
> states. I think mentioning it here that remote accesses are strongly discouraged
> with a reasonable explanation of the implications should be enough. There might
> always be rare situations where remote accesses might be necessary.

Remote percpu updates are extremely rare events. If the cpu is idle/asleep
then usually no updates are needed because no activity is occurring on
that cpu.
